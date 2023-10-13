gem 'devise'
gem_group :development, :test do
    gem "standard"
    gem "faker"
    gem "rspec-rails", "~> 6.0.0"
    gem "factory_bot_rails"
    gem "rails-controller-testing"
end

gem_group :test do
    gem "shoulda-matchers", "~> 5.0"
end

rails_command("bundle")

#Devise Setup
generate("devise:install")
environment 'config.action_mailer.default_url_options = { host: "localhost", port: 3000 }', env: 'development'
generate("devise", "User")

#Rspec setup
generate("rspec:install")

#Shoulda Matchers setup
append_to_file 'spec/rails_helper.rb' do
    <<-CODE
  
  # Shoulda Matchers Configuration
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
    CODE
  end
  

generate(:controller, "static_pages", "index")
route "root to: 'static_pages#index'"

file 'app/components/foo.rb', <<-CODE
  class Foo
  end
CODE

rails_command("db:create db:migrate")

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end