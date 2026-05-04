class WorkController < ApplicationController
  before_action :authenticate_user!

  def index
    @themes = Theme.order(:id)
    @selected_theme_id = params[:theme_id].to_i
    if @selected_theme_id.positive?
      @images = Theme.find(@selected_theme_id).images.order(:id)
      @current_index = 0
      @current_image = @images.first
      @user_value    = Value.find_by(user: current_user, image: @current_image)&.value
    end
  end

  # GET /work/next_image (JSON API)
  def next_image
    api_step(+1)
  end

  # GET /work/prev_image (JSON API)
  def prev_image
    api_step(-1)
  end

  # POST /work/save_value (JSON)
  def save_value
    image = Image.find(params[:image_id])
    val = Value.find_or_initialize_by(user: current_user, image: image)
    val.value = params[:value].to_i

    if val.save
      render json: {
        ok: true,
        message: t("work.saved"),
        ave_value: image.reload.ave_value
      }
    else
      render json: { ok: false, errors: val.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def api_step(step)
    images    = Theme.find(params[:theme_id]).images.order(:id)
    new_index = (params[:index].to_i + step) % images.size
    image     = images[new_index]
    user_value = Value.find_by(user: current_user, image: image)&.value

    render json: {
      index: new_index,
      image_id: image.id,
      name: image.name,
      file: image.file,
      file_url: ActionController::Base.helpers.image_path(image.file),
      ave_value: image.ave_value,
      user_value: user_value
    }
  end
end