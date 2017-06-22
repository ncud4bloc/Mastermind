module MasterMindMethods

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def greeting
    puts " "
    puts "               ---------------------------"
    puts "              |    M A S T E R M I N D    |"
    puts "               ---------------------------"
    puts " "
    puts " "
    puts "***********************************************************"
    puts "*                                                         *"
    puts "* Welcome to Mastermind, the game where the code-breaker  *"
    puts "* must determine the color and order of the counters the  *"
    puts "* code-maker has hidden at the start of each game. There  *"
    puts "* are 6 different colors to choose from, and 4 locations  *"
    puts "* at which to position the colored pegs.                  *"
    puts "*                                                         *"
    puts "* The peg colors are: Red(R), Green(G), Blue(B), Cyan(C), *"
    puts "* Yellow(Y), and Violet(V).                               *"
    puts "*                                                         *"
    puts "* The code-breaker has 12 turns to figure out the proper  *"
    puts "* colored counters and place them in their correct order. *"
    puts "* After each turn the code-maker will provide feedback to *"
    puts "* the right of the code-breaker\'s peg row.                *"
    puts "*                                                         *"
    puts "* The feedback consists of Black(B) and White(W) pegs. A  *"
    puts "* black peg indicates the code-breaker has a peg of the   *"
    puts "* correct color located at the correct position, while a  *"
    puts "* white peg signifies correct color only. For example, a  *"
    puts "* feedback of \"BBW\" indicates that the code-breaker has   *"
    puts "* two correctly colored pegs in the correct positions and *"
    puts "* a third correctly colored peg in an incorrect position. *"
    puts "*                                                         *"
    puts "* The code-maker goes first...GOOD LUCK!                  *"
    puts "*                                                         *"
    puts "***********************************************************"
    puts " "
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def init_players
    @players = {}
    @role = ""
    invalid = true
    while invalid == true

      for num in 1..2
        @player = "plyr" + num.to_s
        if num == 1
          @role = "Code-maker"
        else
          @role = "Code-breaker"
        end
        puts " "
        puts "Is #{@role} a computer (y/n)?"
        puts " "
        answer = gets.chomp.downcase
          if answer.to_s != "y" && answer.to_s != "n"
            puts "Invalid entry. Please enter \"y\" or \"n\"."
          elsif answer.to_s == "y"
            @players[@player] = "Computer"
            puts " "
            puts "#{@role} is #{@players[@player]}"
            puts " "
          else 
            puts " "
            puts "#{@role}, please enter your name:"
            @name = gets.chomp.downcase
            @players[@player] = @name.to_s.capitalize
            puts " "
            puts "#{@role} is #{@players[@player]}"
            puts " "
          end
        invalid1 = false
      end
      invalid = false
    end
    puts "#{@players}"
    puts " "
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def t0_setup
    @my_big_input_array = []
    @my_big_result_array = []
    for num in 1..12
      playing_board(num)
    end
      solution_board
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def playing_board(row_id)
    @breaker_row = ["*", "*", "*", "*"]
    @res_row = ["-", "-", "-", "-"]
    puts "| " + "#{@breaker_row[0..3].join(" | ")}" + " |   -->   Result: < #{@res_row[0..3].join(" ")} >"
    #puts "| " + "#{@breaker_row[0..3].join(" | ")}" + " |   -->   Row #{row_id} result: < #{@res_row[0..3].join(" ")} >"
    puts " "
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def solution_board
    @maker_row = ["?", "?", "?", "?"]
    puts " "
    puts "| " + "#{@maker_row[0..3].join(" | ")}" + " |   -->   The hidden solution!"
    puts " "
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def row_to_find
    create_coded_row
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def iterate_and_check
    create_row
    check_row
    #plot_updated_row(1)
    victory
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def create_coded_row
    @current_player = @players["plyr1"]
    @current_player.capitalize!
    @hidden_row = []
    if @current_player == "Computer"
      @color_pegs = ["R", "G", "B", "Y", "V", "C"]

      for index in 0..3 
        duplicate = true
        while duplicate == true
          rdm_index = rand(6)
          if @hidden_row.include? @color_pegs[rdm_index]
            duplicate = true
          else
            duplicate = false
          end
        end
        @hidden_row[index] = @color_pegs[rdm_index]
      end

      puts " "
      puts "Computer-generated hidden row is #{@hidden_row}"
      puts " "
    else
      @inputted = false
      while @inputted == false
        puts "#{@current_player}, please enter coded"
        puts "counters that are hidden:"
        @pegs_coded_unformatted = gets.chomp.upcase
        @pegs_coded_formatted = @pegs_coded_unformatted.split("")
        peg_check(@pegs_coded_formatted)
      end
      for index in 0..3 
        @hidden_row[index] = @pegs_coded_formatted[index]
      end
      puts " "
      puts "Coded row created will eventually be hidden from view"
      puts "Here\'s the hidden row: #{@hidden_row}"
      puts " "
    end
  end 

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def create_row
    @current_player = @players["plyr2"]
    @current_player.capitalize!
    @game_row_update = []
    if @current_player == "Computer"
      @current_player = "human code-breaker"
      puts " "
      puts "For now the code-breaker will be a #{@current_player}."
      puts " "
    end
    @inputted = false
    while @inputted == false
      puts "#{@current_player.capitalize}, please enter your colored"
      puts "pegs (R, G, B, Y, V, or C) in the"
      puts "order you desire, with no duplicates:"
      @pegs_unformatted = gets.chomp.upcase
      #@pegs_formatted = @pegs_unformatted.scan /\w/
      @pegs_formatted = @pegs_unformatted.split("")
      #puts "#{@pegs_formatted}"
      peg_check(@pegs_formatted)
      #puts "Checkout result: #{@inputted}"
    end
    for index in 0..3 
      @game_row_update[index] = @pegs_formatted[index]
    end
    #puts " "
    #puts "Here\'s the newly created @game_row: #{@game_row_update}"
    #puts " "
  end 

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def peg_check(peg_array)

    @test1 = false
    @test2 = false

    if peg_array.length != 4 
      @test1  = false
      puts " "
      puts "Bad number of pegs....please enter 4 pegs:"
      puts " "
    else
      @test1 = true
    end
    
    peg_array.each do |arr|
      if (arr != "R" && arr != "G" && arr != "B" && arr != "Y" && arr != "V" && arr != "C")
        @test2  = false
        puts " "
        puts "Bad peg color input....please re-enter:"
        puts " "
      break
      else
        @test2 = true
      end
    end

    if @test1 == false || @test2 == false
      @inputted = false
    else
      @inputted = true
    end

  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def check_row
    @winner = false
    @code_breaker_guess = @game_row_update
    @code_breaker_guess.each {|n| n.upcase!}
    @code_maker_solution = @hidden_row
    @code_maker_solution.each {|n| n.upcase!}
    @result = []

    @black_counter = 0
    @white_counter = 0
    @no_counter = 0

    for num in 0..3
      if (@code_maker_solution.include? @code_breaker_guess[num]) && (@code_breaker_guess[num] == @code_maker_solution[num])
        @black_counter += 1
          if @black_counter == 4
            @winner = true
          end
      elsif
        (@code_maker_solution.include? @code_breaker_guess[num]) && (@code_breaker_guess[num] != @code_maker_solution[num])
        @white_counter += 1
      else
        @no_counter += 1
      end
    end

    #puts "Number black: #{@black_counter}"
    #puts "Number white: #{@white_counter}"

    for bc in 0...@black_counter
      @result.push("B")
    end

    for wc in 0...@white_counter
      @result.push("W")
    end

    for nc in 0...@no_counter
      @result.push("-")
    end

    #puts " "
    #puts "Result Matrix:  #{@result}"
    puts " "

  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def big_input_array
    @my_big_input_array.push(@code_breaker_guess)
    #puts " "
    #puts "---------"
    #puts "#{@code_breaker_guess}"
    #puts "#{@my_big_input_array}"
    #puts "---------"
    #puts " "
    #puts " "
    #puts "#{@my_big_input_array}"
    #puts " "
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def big_result_array
    @my_big_result_array.push(@result)
    #puts " "
    #puts "#{@my_big_result_array}"
    #puts " "
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>


  def plot_updated_row(row_id)
    @guess_row = @code_breaker_guess
    @res_row = @result
    puts " "
    puts "| " + "#{@guess_row[0..3].join(" | ")}" + " |   -->   Row #{row_id} result: < #{@res_row[0..3].join(" ")} >"
    puts " "
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def victory
    @current_player = @players["plyr2"]
    unless @winner == false
      @over = true
      puts " "
      puts " Code-breaker #{@current_player} wins!!"
      puts " "
    end
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def defeat
    @current_player = @players["plyr2"]
    if @it == 12
      puts " "
      puts " Code-breaker #{@current_player} loses!!"
      puts " "
      puts "Solution is #{@result}"
      puts " "
    end
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def plot_game 
      j = 12 - @it
      case @it
        when 2
          puts " "
          puts "| " + "#{@my_big_input_array[0][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[0][0..3].join(" ")} >"
          #puts " "
        when 3
          puts " "
          puts "| " + "#{@my_big_input_array[0][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[0][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[1][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[1][0..3].join(" ")} >"
          #puts " "
        when 4
          puts " "
          puts "| " + "#{@my_big_input_array[0][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[0][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[1][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[1][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[2][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[2][0..3].join(" ")} >"
          #puts " "
        when 5
          puts " "
          puts "| " + "#{@my_big_input_array[0][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[0][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[1][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[1][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[2][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[2][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[3][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[3][0..3].join(" ")} >"
          #puts " "
        when 6
          puts " "
          puts "| " + "#{@my_big_input_array[0][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[0][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[1][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[1][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[2][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[2][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[3][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[3][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[4][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[4][0..3].join(" ")} >"
          #puts " "
        when 7
          puts " "
          puts "| " + "#{@my_big_input_array[0][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[0][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[1][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[1][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[2][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[2][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[3][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[3][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[4][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[4][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[5][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[5][0..3].join(" ")} >"
          #puts " "
        when 8
          puts " "
          puts "| " + "#{@my_big_input_array[0][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[0][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[1][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[1][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[2][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[2][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[3][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[3][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[4][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[4][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[5][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[5][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[6][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[6][0..3].join(" ")} >"
          #puts " "
        when 9
          puts " "
          puts "| " + "#{@my_big_input_array[0][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[0][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[1][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[1][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[2][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[2][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[3][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[3][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[4][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[4][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[5][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[5][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[6][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[6][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[7][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[7][0..3].join(" ")} >"
          #puts " "
        when 10
          puts " "
          puts "| " + "#{@my_big_input_array[0][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[0][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[1][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[1][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[2][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[2][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[3][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[3][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[4][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[4][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[5][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[5][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[6][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[6][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[7][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[7][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[8][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[8][0..3].join(" ")} >"
          #puts " "
        when 11
          puts " "
          puts "| " + "#{@my_big_input_array[0][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[0][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[1][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[1][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[2][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[2][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[3][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[3][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[4][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[4][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[5][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[5][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[6][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[6][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[7][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[7][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[8][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[8][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[9][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[9][0..3].join(" ")} >"
          #puts " "
        when 12
          puts " "
          puts "| " + "#{@my_big_input_array[0][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[0][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[1][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[1][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[2][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[2][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[3][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[3][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[4][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[4][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[5][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[5][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[6][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[6][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[7][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[7][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[8][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[8][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[9][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[9][0..3].join(" ")} >"
          puts " "
          puts "| " + "#{@my_big_input_array[10][0..3].join(" | ")}" + " |   -->   Result: < #{@my_big_result_array[10][0..3].join(" ")} >"
          #puts " "
      end


      plot_updated_row(@it)

      for num in 1..j
        playing_board(num + 1)
      end
        solution_board

  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

end

#************************************************************************
#
# Classes defined below
#
#************************************************************************

#************************************************************************

class Game
  include MasterMindMethods

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>
  
  def initialize
    greeting
    init_players
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def play
    t0_setup
    row_to_find

    for @it in 1..12
      unless @over == true
        iterate_and_check
        big_input_array
        big_result_array
        plot_game
        defeat
      end
    end

  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

end

#************************************************************************

mm = Game.new
mm.play