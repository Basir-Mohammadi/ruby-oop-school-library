require './person'
require './student'
require './decorators'

def main
  student_x = Student.new(age: 9, name: 'JD', classroom: '4th Grade')
  puts "Can student named #{student_x.name} use service?"
  puts "R/ #{student_x.can_use_service?}"
  puts student_x.play_hooky

  person = Person.new(age: 22, name: 'maximilianus')
  puts "Original name is: #{person.correct_name}"
  titled_person = CapitalizeDecorator.new(person)
  puts "After capitalization, name is: #{titled_person.correct_name}"
  titled_trimmed_person = TrimmerDecorator.new(titled_person)
  puts "After both capitalization & trim, name is: #{titled_trimmed_person.correct_name}"
end

main
