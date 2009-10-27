require 'acts_as_authenticated'
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Authenticated)

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!( 
  :full => "%d %B %Y",
  :dmy => "%d/%m/%Y",
  :short_timestamp => "at %I:%M %p on %d %B, %Y"
) 

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!( 
  :full => "%d %B %Y",
  :dmy => "%d/%m/%Y"
) 

ExceptionNotifier.exception_recipients = %w(chris@feedmechocolate.com)
ExceptionNotifier.sender_address = %("Application Error" <notifier@bunnylove.org.uk>)
ExceptionNotifier.email_prefix = "[Bunny Love]"
