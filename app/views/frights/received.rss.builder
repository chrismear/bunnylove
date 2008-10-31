xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("My Bunny Love Frights")
    xml.link(frights_url)
      @received_frights.each do |fright|
        xml.item do
          xml.title(truncate(decode_message(fright.message)))
          xml.description(decode_message(fright.message))
          xml.pubDate(fright.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
          xml.link(frights_url(:anchor => "received_fright_#{fright.id}"))
        end
      end
  }
}
