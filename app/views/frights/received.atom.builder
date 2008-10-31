atom_feed(:schema_date => "2008") do |feed|
  feed.title("My Bunny Love Frights")
  feed.update(@received_frights.empty? ? Time.now.utc : @received_frights.first.created_at)
  @received_frights.each do |fright|
    feed.entry(fright, :url => frights_url(:anchor => "received_fright_#{fright.id}")) do |entry|
      entry.title(truncate(decode_message(fright.message)))
      entry.content(decode_message(fright.message))
    end
  end
end
