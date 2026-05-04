# Beer Rating — курсовой проект на Ruby on Rails

Веб-приложение «Рейтинг марок пива»: пользователи регистрируются,
выбирают категорию (лагер / стаут / пшеничное), оценивают марки пива
по шкале 1–10. Для каждой марки рассчитывается средняя экспертная оценка.

## Стек

- Ruby 3.3.6
- Rails 7.1.6
- PostgreSQL 16
- HAML, Sass, Bootstrap 5
- importmap-rails (без webpack/vite)
- has_secure_password (bcrypt) — собственная аутентификация
- i18n с переключением ru/en
- RSpec для тестов

## Реализованный функционал

1. Постраничная структура — controllers, views, routes
2. PostgreSQL: 3 БД (development/test/production), 4 модели, миграции
3. Модели и работа с ними: User, Theme, Image, Value
4. Регистрация и аутентификация (has_secure_password + remember_token в cookie)
5. Рабочая область: кнопки оценки 1–10, листание изображений, JS
6. API на JSON: `/work/next_image`, `/work/prev_image`, `/work/save_value`
   с AJAX-вызовами через `fetch`
7. Локализация: русский (по умолчанию) и английский с переключением через
   флажки в шапке

## Структура моделей

- **User** — пользователь (имя, email, password_digest, remember_token)
- **Theme** — категория пива (лагеры / стауты / пшеничное)
- **Image** — марка пива (name, file, ave_value, theme_id)
- **Value** — оценка пользователя (user_id, image_id, value 1–10)

При сохранении оценки автоматически пересчитывается среднее значение для
изображения (через `after_save :update_image_average`).

## Запуск локально

Требуется: Ruby 3.3.6 (через rbenv), PostgreSQL 16, Node.js 20+, Yarn.

```bash
git clone https://github.com/ТВОЙ_ЛОГИН/beer_rating_app.git
cd beer_rating_app

# установка гемов и npm-пакетов
bundle install
yarn install

# создание БД (предварительно создать роль beer_app_user в Postgres)
bin/rails db:create db:migrate db:seed

# запуск (поднимет Rails + nodemon-сборщик CSS)
bin/dev
```

Открыть `http://localhost:3000`.

Демо-аккаунт: `demo@example.com` / `password`

## Тесты

```bash
bundle exec rspec
```
