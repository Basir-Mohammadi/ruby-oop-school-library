class UserPrompt
  def process(choice)
    raise NotImplementedError
  end

  private

  def prompt(type: :int, prefix: 'Select ', suffix: 'option: ')
    print "#{prefix}#{suffix}"
    value = gets.chomp
    value = value.to_i if type == :int && value != '..'
    value == '..' ? nil : value
  end

  def nil_prompt(suffix, type = :int)
    prompt(prefix: '', suffix: suffix, type: type)
  end

  def list_with_index(array, sep: '. ', top: 1)
    array.each_with_index { |e, i| puts "#{i + top}#{sep}#{e}" }
  end
end
