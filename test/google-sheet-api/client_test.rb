require "test_helper"

class GoogleSheetApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GoogleSheetApi::VERSION
  end

  def test_that_the_client_has_compatible_api_version
    assert_equal 'v1', GoogleSheetApi::Client.compatible_api_version
  end

  def test_that_the_client_has_api_version
    assert_equal 'v1 2023-08-29', GoogleSheetApi::Client.api_version
  end
end
