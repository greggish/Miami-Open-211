class Phone
  include Hashable, Allable
  attr_accessor :id, :number
  @@next_id = 1

  def initialize(number)
    @id = @@next_id
    @@next_id += 1

    self.number = number

    @@all << self
  end
end