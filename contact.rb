class Contact
  include Hashable, Allable
  attr_accessor :id, :name, :title, :email, :phone

  def initialize(row)
  	self.name = row[21]
    self.title = row[22]
    self.email = row[23]

    self.phone = Phone.new(row[24])

    @@all << self
  end
end