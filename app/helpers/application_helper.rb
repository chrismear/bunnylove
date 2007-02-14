# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def standard_flashes(default_message = nil)
    output = ""
    [:notice, :success, :error].each do |flash_type|
      output += "<p class=\"#{flash_type}Message\">#{flash[flash_type]}</p>" if flash[flash_type]
    end
    
    if output == "" && default_message
      output = "<p>#{default_message}</p>"
    end
    
    output
  end
  
  def error_messages_for(object)
    object = instance_variable_get("@#{object}") if object.is_a? Symbol
    if object && object.errors.count != 0
      error_messages = object.errors.full_messages.map {|msg| content_tag(:li, msg) }
      content_tag("ul", error_messages, :class => "error_messages")
    end
  end
end
