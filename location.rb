class Location < ActiveRecord::Base
  belongs_to :organization
  has_many :services
  has_many :addresses
  has_many :mail_addresses

  def self.from_row(row)
    service = Service.find_by_row row
    if service.nil?      
      service = Service.from_row(row)
      service.save

      loc = Location.new
      loc.services << service
    else
      loc = service.location
      # TODO: update service?
    end

    # Is this the service address or the organization address?
    # OHANA only supports org.location addresses
    if row[:address_type] == 'Physical'
      add = Address.from_row(row)
      add.save
      loc.addresses << add
    elsif row[:address_type] == 'Mailing'
      madd = MailAddress.from_row(row)
      madd.save
      loc.mail_addresses << madd
      # 	self.mail_address = MailAddress.new(row)
    else
      puts "What's this?", row
    end
    loc
  end
end
