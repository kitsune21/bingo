ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActionDispatch::IntegrationTest
  # Log in as a particular user.
  def log_in_as(user, password: "password")
    post login_url,
      params: { email_address: user.email_address, password: password }
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
