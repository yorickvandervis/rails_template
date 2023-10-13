# Clone the GitHub repository containing the font files
git clone: "https://github.com/yorickvandervis/rails_template/blob/main/CalSans-SemiBold.woff2", to: "tmp/fonts"
git clone: "https://github.com/yorickvandervis/rails_template/blob/main/Inter.ttf", to: "tmp/fonts"

# Move the font files from tmp/fonts to assets/fonts
FileUtils.mv("tmp/fonts", "app/assets/fonts")

gem "devise"
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

# Devise Setup
generate("devise:install")
environment 'config.action_mailer.default_url_options = { host: "localhost", port: 3000 }', env: "development"
generate("devise", "User")

# Rspec setup
generate("rspec:install")

# Shoulda Matchers setup
append_to_file "spec/rails_helper.rb" do
  <<~CODE
      
    # Shoulda Matchers Configuration
    Shoulda::Matchers.configure do |config|
        config.integrate do |with|
            with.test_framework :rspec
            with.library :rails
        end
    end
  CODE
end

append_to_file "app/javascript/controllers/index.js" do
  <<~CODE
    
    import DarkToggleController from "./dark_toggle_controller"
    application.register("dark-toggle", DarkToggleController)
  CODE
end

# Basic Shared views, like dark toggle and navbar
file "app/views/shared/_darktoggle.html.erb", <<~CODE
  <button data-controller="dark-toggle" data-action="dark-toggle#toggle" type="button" class="inline-block align-middle nav-link font-medium text-gray-500 hover:text-blue-600 dark:text-gray-400 dark:hover:text-blue-500 transistion:all transform duration-300">
    <svg data-dark-toggle-target="dark" xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 transform-none" height="24" width="24" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-moon"><path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/></svg>
    <svg data-dark-toggle-target="light" xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 transform-none" height="24" width="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-sun-dim"><circle cx="12" cy="12" r="4"/><path d="M12 4h.01"/><path d="M20 12h.01"/><path d="M12 20h.01"/><path d="M4 12h.01"/><path d="M17.657 6.343h.01"/><path d="M17.657 17.657h.01"/><path d="M6.343 17.657h.01"/><path d="M6.343 6.343h.01"/></svg>
  </button>

CODE

# Replace the existing application.html.erb with the one from GitHub
remove_file "app/views/layouts/application.html.erb"
file "app/views/layouts/application.html.erb", "https://raw.githubusercontent.com/yorickvandervis/rails_template/main/snippets/application.html.erb"

# Define the content you want in your tailwind.config.js
remove_file "tailwind.config.js"
file "tailwind.config.js", "https://raw.githubusercontent.com/yorickvandervis/rails_template/main/snippets/tailwind.config.js"

generate(:controller, "static_pages", "index")
route "root to: 'static_pages#index'"

file "app/components/foo.rb", <<-CODE
  class Foo
  end
CODE

rails_command("db:create db:migrate")

after_bundle do
  git :init
  git add: "."
  git commit: %( -m 'Initial commit' )
end
