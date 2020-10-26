class WordGame

  #####################################################################  
  # You will need to add the necessary class methods, attributes, 
  # etc. in this class to make the tests in spec/wordgame_spec.rb pass.
  #####################################################################
    
  # Each game is for a single word.  If you want to 
  # play a new game, you create a new instance of WordGame.
  def initialize(word)
    @word = word.downcase
    @guesses =""
    @wrong_guesses =""
  end  
  # INSERT methods and attributes, etc. here as needed.  
    
    def word
        return @word
    end
    
    def guesses
        return @guesses
    end
    
    def wrong_guesses
        return @wrong_guesses
    end
    
    def word_with_guesses ()
        displayed= "-" * @word.length
        for j in 0..@word.length-1
            if @guesses.include? (@word[j])
                displayed[j] = @word[j]
            else
                displayed[j] = '-'
            end
        end
        return displayed
    end
    
    def check_win_or_lose ()
        displayed= "-" * @word.length
        for j in 0..@word.length-1
            if @guesses.include? (@word[j])
                displayed[j] = @word[j]
            else
                displayed[j] = '-'
            end
        end
        counter = false
        if displayed == @word
            counter = true
        end
        
        if @wrong_guesses.length <=6 
            if counter == true
                return :win
            else
                return :play
            end
        else
            return :lose
        end
    end
    
    def guess (letter)
        if letter=="" || /[A-Za-z]/ !~ letter || letter.nil?
            raise ArgumentError 
        end
        letter = letter.downcase
            
            #correct letter
            if (@word.include? (letter)) 
                if (@guesses.include? (letter))
                    return false
                else
                    @guesses = @guesses + letter
                    @wrong_guesses = @wrong_guesses
                    return true
                end
            else
                if (@wrong_guesses.include? (letter))
                    return false
                else
                    @guesses = @guesses
                    @wrong_guesses = @wrong_guesses +letter
                    return true
                end
            end
    end
    
  # Get a word from remote "random word" service.  Do not change.
  #     
  # You can test get_random_word by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end