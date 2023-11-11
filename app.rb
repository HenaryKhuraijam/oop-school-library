require './student'
require './teacher'
require './book'
require './rental'
require 'io/console'
class App
  def initialize
    @books = []
    @persons = []
    @rentals = []
  end

  def back_to_main_menu
    print "\n\nPress any key to return to the main menu...."
    $stdin.getch
  end

  def choice_bool(test = '', str = '', type = 'i')
    print "\n#{str}\nPress any key to return to the main menu ..."
    type == 'i' ? test.include?($stdin.getch.to_i) : test.include?($stdin.getch)
  end

  def list_items(items, label, empty_msg)
    if items.empty?
      puts "#{label} is empty! #{empty_msg}"
    else
      print "\n====== List of #{label} =======\n\n"
      items.each { |item| puts item }
    end
    back_to_main_menu
  end

  def create_person(type)
    name = name_title('name')
    age = age_entry
    if type == 1
      permission = choice_bool(%w[Y y], 'Whether have parent permission [Y/N]: ', 's')
      person = Student.new(age, name, parent_permission: permission)
    else
      specialization = name_title('specialization')
      person = Teacher.new(age, specialization, name)
    end
    @persons << person
    display_person_info(person)
  end

  def display_person_info(person)
    print "\n\nID: #{person.id} Name: #{person.name} Age: #{person.age}"
    print person.is_a?(Student) ? " Parent Permission: #{person.parent_permission}" : ''
    print "\nNew #{person.class} is created successfully!\n"
  end

  def create_a_person
    add_item = true
    while add_item
      create_person(person_type)
      add_item = choice_bool(%w[Y y], "Press [Y/y] to add another person\nOr", 's')
    end
  end

  def create_a_book
    add_item = true
    while add_item
      title = name_title('title')
      author = name_title('author')
      book = Book.new(title, author)
      @books << book
      print "\n\nTitle: #{book.title} Author: #{book.author}"
      print "\nNew Book is created successfully!\n"
      add_item = choice_bool(%w[Y y], "Press [Y/y] to add another book\nOr", 's')
    end
  end

  def create_a_rental
    add_item = check_books_persons
    while add_item
      sel_book = @books[sel_item_by_no(@books, 'book')]
      sel_person = @persons[sel_item_by_no(@persons, 'person')]
      date = input_date
      @rentals << Rental.new(date, sel_person, sel_book)
      display_rental_info(date, sel_book, sel_person)
      add_item = choice_bool(%w[Y y], "Press [Y/y] to add another rental\nOr", 's')
    end
  end

  def sel_item_by_no(items, label)
    sel_mode = false
    until sel_mode
      print "\nSelect a #{label} from the following list by number\n"
      items.each.with_index { |item, index| puts "No: #{index + 1}) #{item}" }
      print "\nEnter your choice: "
      sel_mode = (1..items.length).include?(opt = gets.chomp.to_i)
    end
    opt - 1
  end

  def display_rental_info(date, sel_book, sel_person)
    print "\n\nDate: #{date} Book: #{sel_book.title} Name: #{sel_person.name}"
    print "\nNew Rental Added Successfully!\n"
  end

  def list_all_rentals
    if @rentals.empty?
      puts 'Rentals List is empty!'
    else
      id = select_person_id
      display_rentals_by_person_id(id)
    end
    back_to_main_menu
  end

  def select_person_id
    selper = false
    until selper
      list_items(@rentals.map { |rental| "#{rental.person.name}, ID: #{rental.person.id}" },
                 'Persons On Rental List', 'Please try entering some rentals first.')
      print 'Enter an ID from the list : '
      id = gets.chomp.to_i
      selper = @rentals.any? { |rental| rental.person.id == id }
    end
    id
  end

  def display_rentals_by_person_id(id)
    person_name = @persons.find { |person| person.id == id }.name
    puts "\nList of books rented to ID: #{id} Name: #{person_name}\n\n"
    @rentals.each { |rental| display_rental_info(rental.date, rental.book, rental.person) if rental.person.id == id }
  end

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
