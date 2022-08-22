#noinspection MissingYardParamTag
class Person
  attr_reader :id
  attr_accessor :age, :name

  def initialize(age, name = 'unknown', parent_permission = true)
    @id = Random.rand(1..100)
    @name = name
    @age = age
    @parent_permission = parent_permission
  end

  private def is_of_age?
    @age >= 18
  end

  def can_use_service?
    is_of_age? && @parent_permission
  end
end
