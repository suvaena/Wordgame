require 'sinatra/base'
require 'sinatra/flash'
require './lib/wordgame.rb'

class WordgameApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || WordGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGame.new(word)
    redirect '/show'
  end
  
  # Use existing methods in WordGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
    ### YOUR CODE HERE ### 
    if (!@game.guess(letter) && ((@game.guesses.include? letter) || (@game.wrong_guesses.include? letter)))
      flash[:message] = "You have already used that letter."
    elsif !@game.guess(letter)
      flash[:message] = "Invalid guess."
    end
      
    # Note: in addition to passing the provided Cucumber tests, you also need
    # to handle repeated guesses and invalid guesses.  See the comments 
    # above for what to set the flash hash to.  See the views/show.erb view
    # to see how the flash hash is used.  You may delete this note.
    redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use 
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    ### YOUR CODE HERE ###
    gamestatus = @game.check_win_or_lose
    if gamestatus == :win
        redirect '/win'
    elsif gamestatus == :play
        erb :show
    else
        redirect '/lose'
    end
    # Note: "erb :show" causes us to process the view show.erb.
    # The views, e.g. show.erb are processed by first using 
    # the layout.erb view, and when it reaches "<%= yield %>", 
    # then the specified view, e.g. show.erb is processed and inserted.
    # The layout.erb view allows us to use the same web page layout
    # for all parts of the app. You may delete this note.
    #  
    erb :show # You may change/remove this line
  end
   
  get '/win' do
    ### YOUR CODE HERE ###
    gamestatus = @game.check_win_or_lose
      if gamestatus == :win
          erb :win
      else
          redirect '/show'
      end
    #to avoid cheating you need to test the game status again
    # Note: If a user goes directly to this route, e.g. they type this 
    # route in directly, they could cheat and see the winning page.
    # You need to write code to redirect them to /show if they
    # have not actually won the game yet or to /lose if they have lost.
    # You may delete this note.
  end
  
  get '/lose' do
    ### YOUR CODE HERE ###
    gamestatus = @game.check_win_or_lose
      if gamestatus == :lose
          erb :lose
      else
          redirect '/show'
      end
    # Note: You need to write code to redirect them to /show if they
    # have not actually lost the game yet or to /win if they have won.
    # You may delete this note.
  end
  
end
