# A simple repository for interview tasks (OF DOOM)

ruby 2.7.5
rails 7.0.8

# How to setup the project for development

1. Copy env file `cp .env.example .env` and fill it
2. Copy database config `cp config/database.yml.example config/database.yml` and fill it
3. Setup database `rails db:setup` and seed data `rails db:seed`
4. Install `foreman` gem `gem install foreman`
5. Run the application `foreman start -f Procfile.dev`
6. Sidekiq web interface will be accessible by address `https://localhost:3000/sidekiq`