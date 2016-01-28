require 'test_helper'

class DictionaryWordsControllerControllerTest < ActionController::TestCase
  test "should get spellcheck" do
    get :spellcheck
    assert_response :success
  end

end
