require './student'
require './teacher'
require './book'
require './rental'
require 'io/console'

class App # rubocop:disable Metrics/ClassLength
  def initialize
    @books = []
    @persons = []
    @rentals = []
  end

  def back_to_main_menu
    print "\n\nPress any key to return to main menu...."
    $stdin.getch
  end

  def choice_bool(test = '', str = '', type = 'i')
    print "\n", str, "\nPress any key to return to main menu ..."
    if type == 'i'
      test.include? $stdin.getch.to_i
    else
      test.include? $stdin.getch
    end
  end

  def list_all_books
    if @books.empty?
      puts 'Book List is empty!'
    else
      print "\n====== List of Books available =======\n\n"
      @books.each { |book| puts "Title: '#{book.title}', Author: #{book.author}" }
    end
    back_to_main_menu
  end

  def list_all_persons
    if @persons.empty?
      puts 'Person List is empty!'
    else
      print "\n====== List of Books available =======\n\n"
      @persons.each { |person| puts "[#{person.class}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}" }
    end
    back_to_main_menu
  end

  def person_type
    opt = 0
    mid_str = "\nEnter Your choice: "
    loop do
      system('clear')
      print "\nCreate a Person\n"
      print "\nEnter 1 to create Student\nEnter 2 to create Teacher", mid_str
      break if (1..2).include?(opt = gets.chomp.to_i)

      mid_str = "\n Invalid Type! Please Enter 1 or 2: "
    end
    opt
  end

  def name_title(str)
    item_valid = false
    msg = "\nPlease Enter #{str}:  "
    until item_valid
      print msg
      item_valid = (name_str = gets.chomp).length.positive?
      msg = "\nInvalid Input! #{str} cannot be empty\nPlease Enter Again: "
    end
    name_str
  end

  def age_entry
    item_valid = false
    until item_valid
      print 'Enter Age: '
      item_valid = (1..100).include?(age = gets.chomp.to_i)
      print 'Enter a valid age between 1 to 100' unless item_valid
    end
    age
  end

  def create_student
    name = name_title('name')
    age = age_entry
    item_valid = false
    until item_valid
      print 'Whether have parent permission [Y/N]: '
      item_valid = %w[Y y N n].include?(permission = $stdin.getch)
      puts
    end
    permission = permission.capitalize == 'Y'
    stud = Student.new(age, name, parent_permission: permission)
    @persons << stud
    print "\n\nID: #{stud.id} Name: #{stud.name} Age: #{stud.age} Parent Permission: #{stud.parent_permission}"
    print "\nNew Student is created successfully!\n"
  end

  def create_teacher
    name = name_title('name')
    age = age_entry
    specialization = name_title('specialization')
    teacher = Teacher.new(age, specialization, name)
    @persons << teacher
    print "\n\nID: #{teacher.id} Name: #{teacher.name} Age: #{teacher.age}"
    print "\nNew Teacher is created successfully!\n"
  end

  def create_a_person
    add_item = true
    while add_item
      if person_type == 1
        create_student
      else
        create_teacher
      end
      add_item = choice_bool(%w[Y y], "Press [Y/y] to add another person\nOr", 's')
    end
  end

  def create_a_book
    add_item = true
    while add_item
      print "\nCreate a book\n"
      title = name_title('title')
      author = name_title('author')
      book = Book.new(title, author)
      @books << book
      print "\n\nTitle: #{book.title} Author: #{book.author}"
      print "\nNew Book is created successfully!\n"
      add_item = choice_bool(%w[Y y], "Press [Y/y] to add another book\nOr", 's')
      system('clear')
    end
  end

  def check_books_persons
    if @books.empty? || @persons.empty?
      puts 'Book list Or Person list is empty!'
      puts 'Please try entering some'
      false
    else
      true
    end
  end

  def sel_book_by_no
    sel_mode = false
    until sel_mode
      print "\nSelect a book from the following list by number\n"
      @books.map.with_index do |book, index|
        puts "No: #{index + 1}) Title: '#{book.title}', Author: #{book.author}"
      end
      print "\nEnter your choice: "
      sel_mode = (1..@books.length).include?(opt = gets.chomp.to_i)
    end
    opt - 1
  end

  def sel_person_by_no
    sel_mode = false
    until sel_mode
      print "\nSelect a person from the following list by number\n"
      @persons.map.with_index do |person, index|
        puts "No: #{index + 1}) Name: '#{person.name}', Age: #{person.age}"
      end
      print "\nEnter your choice: "
      sel_mode = (1..@persons.length).include?(opt = gets.chomp.to_i)
    end
    opt - 1
  end

  def create_a_rental
    add_item = check_books_persons
    while add_item
      sel_book = @books[sel_book_by_no]
      sel_person = @persons[sel_person_by_no]
      print "\nEnter a date [format yyyy/mm/dd]: "
      date = gets.chomp
      @rentals << Rental.new(date, sel_person, sel_book)
      print "\nDate: #{date} Book: #{sel_book.title} Name: #{sel_person.name}"
      print "\nNew Rentals Added Successfully!\n"
      add_item = choice_bool(%w[Y y], "Press [Y/y] to add another rental\nOr", 's')
    end
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  def list_all_rentals # rubocop:disable Metrics/CyclomaticComplexity
    selper = false
    if @rentals.empty?
      puts 'rentals List is empty!'
    else
      until selper
        system('clear')
        print "\n====== List of Persons On Rental List =======\n\n"
        @rentals.each { |rental| puts "Name: #{rental.person.name}, ID: #{rental.person.id}" }
        print 'Enter an ID from the list : '
        id = gets.chomp.to_i
        @rentals.each { |rental| selper = true if rental.person.id == id }
      end
      nam1 = @persons.find { |person| person.id == id }
      puts "\nList of books rented to ID: #{id} Name: #{nam1.name}\n\n"
      @rentals.each do |rental|
        if rental.person.id == id
          puts "Date: #{rental.date}. Book: '#{rental.book.title}' Author: #{rental.book.author}"
        end
      end
    end
    back_to_main_menu
  end
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/MethodLength

  def exit_app
    system('clear')
    print "\n" * 3, "\t" * 3, '|| ', '=' * 8, ' Thanks For Using OOP School Library Application ',
          '=' * 8, ' ||', "\n" * 3
    exit
  end

  def app_run(func)
    system('clear')
    method(func).call
    "\nEnter your choice (1 - 7): "
  end
end
