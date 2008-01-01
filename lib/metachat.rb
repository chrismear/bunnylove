require 'net/http'
require 'uri'
require 'cgi'

class Metachat
  def self.check_secret(username, secret)
    response = Net::HTTP.get_response(self.user_page_uri(username))
    response.body =~ Regexp.new(secret)
  end
  
  def self.user_page_uri(username)
    URI.parse("http://metachat.org/users/#{CGI.escape(username)}")
  end
end