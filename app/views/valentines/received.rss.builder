xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("My Bunny Love Valentines")
    xml.link(received_valentines_url(:format => :rss))
      @received_valentines.each do |valentine|
        xml.item do
          xml.title(truncate(decode_message(valentine.message)))
          xml.description(decode_message(valentine.message))
          xml.pubDate(valentine.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
          xml.link(bunny_url("current"))
        end
      end
  }
}
