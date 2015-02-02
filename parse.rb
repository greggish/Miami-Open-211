require 'csv'

#FILENAME = 'MiamiOpen211_Demo_600_records.csv'
FILENAME = 'MiamiOpen211_Demo_600_records.scrubbed.csv'

module Hashable
  def to_hash
    hash = {}
    instance_variables.each do |var| 
      val = instance_variable_get(var)
      hash[var.to_s.delete("@")] = if val.respond_to? :to_hash
                                     val.to_hash
                                   else
                                     val
                                   end
    end
    hash
  end
end

# columns
# 0: Provider
# 1: Provider ID
# 2: Provider Name
# 3: Provider Parent Provider
# 4: Provider Description
# 5: Provider Eligibility
# 6: Provider Hours
# 7: Provider Intake / Application Process
# 8: Provider Languages
# 9: Provider Program Fees
# 10: Provider Shelter Requirements
# 11: Provider Volunteer Opportunities
# 12: Provider Website Address
# 13: Address Type
# 14: Address Line1
# 15: Address Line2
# 16: Address City
# 17: Address Province
# 18: Address Postal Code
# 19: Address County
# 20: Address Is Primary Address
# 21: Contact Name
# 22: Contact Title
# 23: Contact Email
# 24: Contact Telephone Number
# 25: Contact Is Primary Contact
# 26: Telephone Number
# 27: Telephone Is Primary Telephone
# 28: Service Code
# 29: Service Code Description
# 30: Service Code Type Service
# 31: Service Code Out Of Resource
# 32: Geography Served by State, State Name

class Organization
  include Hashable
  attr_accessor :name, :id, :description, :url, :location, :contact, :phone
  @@all = []

  def initialize(row)
    self.id = row[1]
    self.name = row[2]
    self.description = row[4]
    self.url = row[12]

    parse_location(row)
    parse_contact(row)
    parse_phone(row)

    @@all << self
  end

  def self.all
    @@all
  end

  def parse_location(row)
    l = Location.new
    l.parse_address(row)

    self.location = l
  end

  def parse_contact(row)
    c = Contact.new
    c.name = row[21]
    c.title = row[22]
    c.email = row[23]

    self.contact = c
  end

  def parse_phone(row)
    p = Phone.new
    p.number = row[26]

    self.phone = p
  end
end

class Location
  include Hashable
  attr_accessor :address

  @@next_id = 1

  def initialize
    @id = @@next_id
    @@next_id += 1
  end

  def parse_address(row)
    a = Address.new
    a.street_1 = row[14]
    a.street_2 = row[15]
    a.city = row[16]
    a.state = row[17]
    a.postal_code = row[18]
    a.country_code = 'US'

    self.address = a
  end
end

class Address
  include Hashable
  attr_accessor :id, :street_1, :street_2, :city, :state, :postal_code, :country_code

  @@next_id = 1
  def initialize
    @id = @@next_id
    @@next_id += 1
  end
end

class Contact
  include Hashable
  attr_accessor :id, :name, :title, :email, :phone

  def parse_phone(row)
    p = Phone.new
    p.number = row[24]

    self.phone = p
  end
end

class Phone
  include Hashable
  attr_accessor :id, :number
  @@next_id = 1

  def initialize
    @id = @@next_id
    @@next_id += 1
  end
end

first = true
item = {}
i = 0
CSV.foreach(FILENAME) do |row|
  #p i, row[0]
  i += 1
  if first
    first = false
    puts "Columns:", row
  else
    Organization.new(row)
  end
end

# test JSON for first two items
require 'json'
puts JSON.dump(Organization.all[0..1].map(&:to_hash))

