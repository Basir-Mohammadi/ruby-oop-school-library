require './student'

def main
  student_x = Student.new(29, 'Jaguar', '4th Grade')
  puts "Can student - <#{student_x.name}> use service?"
  puts "R/ #{student_x.can_use_service?}"
  puts student_x.play_hooky
end

main
