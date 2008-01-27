atom_feed(:schema_date => "2008") do |feed|
  feed.title("My Bunny Love Valentines")
  feed.update(@received_valentines.empty? ? Time.now.utc : @received_valentines.first.created_at)
  @received_valentines.each do |valentine|
    feed.entry(valentine, :url => valentines_url(:anchor => "received_valentine_#{valentine.id}")) do |entry|
      entry.title(truncate(decode_message(valentine.message)))
      entry.content(decode_message(valentine.message))
    end
  end
end
