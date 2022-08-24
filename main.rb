#! /usr/bin/env ruby

require './app'

class Factory
  def initialize
    @app = App.new
  end

  def run
    show_allowed_options
    prompt
  end

  def create_person
    puts 'Which person?'
    list_with_index(%w[Student Teacher])
    choice = prompt(prefix: 'Choose', suffix: 'person: ')
    return if choice.nil? || ![1, 2].include?(choice)

    age = prompt(suffix: 'age: ')
    return if age.nil?

    name = prompt(type: :str, suffix: 'name: ')
    return if name.nil?

    choice == 1 ? create_student(age, name) : create_teacher(age, name)
  end

  def create_classroom
    label = prompt(type: :str, suffix: 'label: ')
    return if label.nil?

    classroom = @app.create_classroom(label)
    puts 'Classroom created successfully!'
    classroom
  end

  def create_book
    title = prompt(type: :str, suffix: 'title: ')
    return if title.nil?

    author = prompt(type: :str, suffix: 'author: ')
    return if author.nil?

    book = @app.create_book(title, author)
    puts 'Book created successfully!'
    book
  end

  def create_rental
    return unless resources?

    puts "Who's borrowing?"
    list_people_with_index
    pc = prompt(prefix: 'Select', suffix: 'person: ')
    ss = @app.students.size
    return if reject_choice?(pc, ss + @app.teachers.size)

    puts 'Which book?'
    @app.books.each_with_index { |b, i| puts "#{i + 1}. #{b.title}" }
    bc = prompt(prefix: 'Select', suffix: 'book: ')
    return if reject_choice?(bc, @app.books.size)

    person = pc < ss ? @app.students[pc] : @app.teachers[pc]
    rental = @app.create_rental(person, @app.books[bc])
    puts 'Rental created successfully!'
    rental
  end

  def list_books
    @app.list_books
  end

  def list_people
    @app.list_people
  end

  def list_classrooms
    @app.list_classrooms
  end

  def list_rentals_by_person
    puts 'Whose rentals do want to retrieve?'
    @app.list_people
    choice = prompt(prefix: '', suffix: 'person ID: ')
    return if reject_choice?(choice, 100)

    @app.find_rentals_by_person(choice)
  end

  def separator(char = '-', size = 100)
    puts char * size
  end

  private

  def prompt(type: :int, prefix: 'Enter', suffix: ' Choice: ')
    value = nil
    loop do
      value = chomp("#{prefix}#{suffix}")
      if type == :int && value != '..'
        begin
          value = Integer(value)
        rescue ArgumentError
          puts 'Error!! Only numbers are accepted'
          next
        end
      end
      break
    end
    value == '..' ? nil : value
  end

  def show_allowed_options
    options = [
      'Create person',
      'Create classroom',
      'Create book',
      'Create rental',
      'List all books',
      'List all people',
      'List all classrooms',
      'List all rentals by person',
      'Quit'
    ]
    list_with_index(options)
  end

  def resources?
    equipped = true
    if @app.students.empty? && @app.teachers.empty?
      puts 'No people available'
      equipped = false
    end

    if @app.books.empty?
      puts 'No books available'
      equipped = false
    end

    equipped
  end

  # @param array [Array]
  def list_with_index(array, sep: '. ', top: 1)
    array.each_with_index { |e, i| puts "#{i + top}#{sep}#{e}" }
  end

  def list_people_with_index
    si = @app.students.size
    @app.students.each_with_index { |s, i| puts "#{i + 1}. #{s.name}" }
    @app.teachers.each_with_index { |t, i| puts "#{i + si}. #{t.name}" }
  end

  def reject_choice?(choice, limit)
    choice.nil? || choice.negative? || choice > limit
  end

  def create_teacher(age, name)
    specialization = prompt(type: :str, suffix: 'specialization: ')
    return if specialization.nil?

    teacher = @app.create_teacher(age, name, specialization)
    puts 'Teacher created successfully!'
    teacher
  end

  def create_student(age, name)
    puts 'Available Classrooms'
    puts '0. Create new'
    @app.classrooms.each_with_index { |c, i| puts "#{i + 1}. #{c.label}" }
    choice = prompt(prefix: 'Select', suffix: 'classroom')
    return if choice.nil?

    classroom = choice.zero? ? create_classroom : @app.classrooms[choice]
    return if classroom.nil?

    student = @app.create_student(age, name, classroom)
    puts 'Student created successfully!'
    student
  end
end

def main
  factory = Factory.new

  loop do
    choice = factory.run
    case choice
    when 1
      factory.create_person
    when 2
      factory.create_classroom
    when 3
      factory.create_book
    when 4
      factory.list_books
    when 6
      factory.list_people
    when 7
      factory.list_classrooms
    when 8
      factory.list_rentals_by_person
    when 9
      puts 'App quitting gracefully..'
      break
    else
      puts 'INVALID OPTION'
    end
    factory.separator
  end
end

main
