// Логика рабочей области пива:
// - перелистывание изображений (AJAX к /work/next_image и /work/prev_image)
// - сохранение оценки (AJAX к /work/save_value)

function initBeerApp() {
  const root = document.getElementById("beer_app");
  if (!root || !window.appPaths) return;

  const state = {
    themeId: parseInt(root.dataset.themeId, 10),
    imageId: parseInt(root.dataset.imageId, 10),
    index:   parseInt(root.dataset.index, 10),
    total:   parseInt(root.dataset.total, 10)
  };

  const $name     = document.getElementById("beer_name");
  const $img      = document.getElementById("beer_img");
  const $avg      = document.getElementById("beer_avg");
  const $value    = document.getElementById("user_value");
  const $position = document.getElementById("beer_position");

  function step(direction) {
    const url = direction > 0 ? window.appPaths.next : window.appPaths.prev;
    const params = new URLSearchParams({
      theme_id: state.themeId,
      index: state.index
    });
    fetch(`${url}?${params.toString()}`, {
      headers: { "Accept": "application/json" }
    })
      .then(r => r.json())
      .then(d => {
        state.index   = d.index;
        state.imageId = d.image_id;
        $name.textContent     = d.name;
        $img.src              = d.file_url;
        $img.alt              = d.name;
        $avg.textContent      = d.ave_value;
        $value.textContent    = d.user_value ?? "—";
        $position.textContent = (d.index + 1);
      })
      .catch(err => console.error("Step error:", err));
  }

  function saveValue(value) {
    fetch(window.appPaths.save, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": window.appPaths.csrf,
        "Accept":       "application/json"
      },
      body: JSON.stringify({ image_id: state.imageId, value: value })
    })
      .then(r => r.json())
      .then(d => {
        if (d.ok) {
          $value.textContent = value;
          $avg.textContent   = d.ave_value;
        } else {
          alert((d.errors || ["Error"]).join("\n"));
        }
      })
      .catch(err => console.error("Save error:", err));
  }

  document.getElementById("next_btn").addEventListener("click", () => step(+1));
  document.getElementById("prev_btn").addEventListener("click", () => step(-1));

  document.querySelectorAll(".btn-rate").forEach(btn => {
    btn.addEventListener("click", () => {
      saveValue(parseInt(btn.dataset.value, 10));
    });
  });
}

// Инициализация и при первой загрузке, и после Turbo-навигации
document.addEventListener("turbo:load", initBeerApp);
document.addEventListener("DOMContentLoaded", initBeerApp);