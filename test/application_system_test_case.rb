require "test_helper"
require_relative 'login_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Warden::Test::Helpers
  include LoginHelper
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  Capybara.server = :puma, { Silent: true }

  def take_failed_screenshot
    false
  end
end
