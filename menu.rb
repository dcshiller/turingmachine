module Menu

  MENU_OPTIONS = ["1. Watch Sample",
             "2. Edit/Write Program (t.b.added)",
             "3. Load Program (t.b.a)",
             "4. Options (t.b.a)",
             "5. Exit"]

 def menu
   selection = -1
   loop do
     print_menu_options(selection)
     next_key = get_keystroke
     if next_key == "\e" then next_key << STDIN.read_nonblock(3) rescue nil end
     if next_key == "\e" then next_key << STDIN.read_nonblock(2) rescue nil end
     sleep(0.2)
     case next_key
     when  "\e[A"
       selection -= 1 unless selection < 1
     when "\e[B"
       selection += 1 unless selection >= MENU_OPTIONS.length - 1
     when "\r", "\n"
       ProgramReader.new.run_program if selection == 0
       system("clear") and exit if selection == 4
     when "b"
       break
     else
     end
   end
  end

  def print_menu_options(selection)
    refresh_window_information
    system("clear")
    puts "\n" * ((@rows / 2) - 7)
    puts center("Turing Machine Simulator\n\n")
    MENU_OPTIONS.each_with_index do |menu_option, idx|
     if idx == selection then justify selected menu_option else justify menu_option end
    end
  end
end
