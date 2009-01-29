# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  attr_accessor :site_name
  
  def site_name
    @site_name || 'Pragprog Books'
  end
end
