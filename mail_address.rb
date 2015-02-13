# Clone of Address Class
class MailAddress < ActiveRecord::Base
  belongs_to :location

  def self.from_row(row)
    madd = MailAddress.find_or_initialize_by street_1: row[:address_line1]

    #madd.street_1 = row[:address_line1]
    madd.street_2 = row[:address_line2]
    madd.city = row[:address_city]
    madd.state = row[:address_province]
    madd.postal_code = row[:address_postal_code]
    madd.country_code = 'US'

    madd
  end
end