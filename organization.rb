class Organization < ActiveRecord::Base
  has_many :locations

  def self.from_row(row)
    name = row[:provider_parent_provider]

    org = Organization.find_or_initialize_by name: name
    org.description = name

    loc = Location.from_row(row)
    loc.save
    org.locations << loc

    org
  end

end