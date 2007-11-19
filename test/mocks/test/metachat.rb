class Metachat
  cattr_accessor :secret_check_succeed
  
  def self.check_secret(username, secret)
    if self.secret_check_succeed
      true
    else
      false
    end
  end
  
  # Same as actual implementation
  def self.user_page_uri(username)
    URI.parse("http://metachat.org/users/#{username.gsub(/ /, '%20')}")
  end
end