require './app'

def main_items
  {
    1 => { name: 'List all books', fun: :list_all_books },
    2 => { name: 'List all people', fun: :list_all_persons },
    3 => { name: 'Create a person', fun: :create_a_person },
    4 => { name: 'Create a book', fun: :create_a_book },
    5 => { name: 'Create a rental', fun: :create_a_rental },
    6 => { name: 'List all rentals for a given person id', fun: :list_all_rentals },
    7 => { name: 'Exit', fun: :exit }
  }
end

def main_menu
  system('clear')
  menu_ui = "\n|****** Welcome to School library App! ******|\n\n"
  main_items.each { |k, v| menu_ui += "#{k} - #{v[:name]}\n" }
  menu_ui += "\n"
  menu_ui
end

def main
  app = App.new
  ui = "\nEnter your choice (1 - 7): "
  add_book = true
  while add_book
    print main_menu, ui
    add_book = ![7].include?(s = gets.chomp.to_i)
    ui = (1..6).include?(s) ? app.app_run(main_items[s][:fun]) : "\nInvalid Choice!\nEnter your choice(1 - 7) again: "
  end
  app.exit_app
end

main
