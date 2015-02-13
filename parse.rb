%w[csv].each { |lib| require lib }
%w[connect organization location service address mail_address].each { |lib| require_relative lib }

infile = ARGV.first

DISPLAY_HEADERS = true

if infile.nil? or not infile.include? 'csv'
  puts "Usage: ruby #{__FILE__} YOUR_FILE.csv"
  exit
end

def display_header_row(row)
  puts "===", "Columns", "==="
  row.each_with_index do |col, idx|
    puts "#{idx},\"#{col.last}\""
  end
  puts "==="
  # if first_row
  #   first_row = false
  # else
end

first = true
CSV.foreach(infile, 
  encoding: 'Windows-1251:UTF-8', 
  headers: true,
  return_headers: true,
  header_converters: :symbol,
) do |row|
  if first
    first = false
    display_header_row(row) if DISPLAY_HEADERS
    next
  end

  require 'pp'
  pp row.to_hash

  Organization.from_row(row).save
end

puts "Organization count: #{Organization.count}"
puts "Service count: #{Service.count}"

# test JSON for first two items
Organization.all.each do |org|
  puts org.name

  puts "\t#{org.locations.count} locations:"
  org.locations.each do |loc|
    puts "\t\tLocation ##{loc.id}"

    puts "\t\t#{loc.services.count} services:"
    loc.services.each do |ser|
      puts "\t\t\t#{ser.name}, #{ser.website}"
    end

    puts "\t\t#{loc.addresses.count} addresses:"
    loc.addresses.each do |add|
      puts "\t\t\t#{add.street_1}, #{add.street_2}"
    end

    puts "\t\t#{loc.mail_addresses.count} mailing addresses:"
    loc.mail_addresses.each do |madd|
      puts "\t\t\t#{madd.street_1}, #{madd.street_2}"
    end
  end
end
