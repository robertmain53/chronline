require 'rubygems'
require 'spork'

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'paperclip/matchers'
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'sunspot/rails/spec_helper'
  require 'webmock/rspec'
  require 'vcr'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join('spec', 'support', '**' '*.rb')].each {|f| require f}

  RSpec.configure do |config|
    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"

    config.include Paperclip::Shoulda::Matchers

    VCR.configure do |c|
      c.cassette_library_dir = 'spec/fixtures/dish_cassettes'
      c.hook_into :webmock
      c.filter_sensitive_data('<EMAIL>') { ENV['PHOTOSHELTER_EMAIL'] }
      c.filter_sensitive_data('<PASSWORD>') { ENV['PHOTOSHELTER_PASSWORD'] }
    end

    config.extend VCR::RSpec::Macros

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with :truncation

      Kernel.silence_warnings do
        Taxonomy.set_taxonomy_tree(
          :sections,
          YAML.load_file(Rails.root.join('spec', 'config', 'taxonomy.yml'))
        )
        Taxonomy.set_taxonomy_tree(
          :blogs,
          YAML.load_file(Rails.root.join('spec', 'config', 'blogs.yml'))
        )
      end
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.include AuthHelper, type: :request
    config.include Helpers
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
end
