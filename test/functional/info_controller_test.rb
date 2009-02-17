require 'test_helper'
require 'nokogiri'

class InfoControllerTest < ActionController::TestCase
  test "who_bought returns XML" do
    get :who_bought, :id => products(:one).id, :format => 'xml'
    doc = Nokogiri::XML(@response.body)
    
    assert_response :success
    puts doc
    assert_tag :tag => 'title', :content => products(:one).title
  end
end
