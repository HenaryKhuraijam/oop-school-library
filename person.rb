class Person
  # getter
  attr_reader :id

  # setter
  attr_accessor :name, :age

  def initialize(age, name = 'Unknown', parent_permission: true)
    @id = Random.rand(1..50)
    @age = age
    @name = name
    @parent_permission = parent_permission
  end

  def can_use_services
    if of_age? || parent_permission
      true
    else
      false
    end
  end

  private

  def of_age?
    @age > 18
  end
end
