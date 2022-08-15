require 'open-uri'

class GamesController < ApplicationController
  def new
    # display a new random grid and a form.
    alphabet = ('a'..'z').to_a
    @grid = []
    (1..8).each do
      @grid << alphabet[rand(0..25)]
    end
    @grid
  end

  def score
    # submitted via post
    answer = params[:answer]
    grid = params[:grid]
    grid = grid.split(' ')
    p grid
    msg = ''
    score_final = 0

    out_of_grid = false
    # check if letter is in the grid
    answer.downcase.chars.each do |letter|
      index = grid.find_index { |l| l == letter }
      p index
      if index
        grid.delete_at(index)
      else
        msg = 'the given word is not in the grid'
        out_of_grid = true
      end
    end

    unless out_of_grid
      # check le mot avec l'api
      url = "https://wagon-dictionary.herokuapp.com/#{answer}"
      api_json = URI.open(url).read
      hash_from_json = JSON.parse(api_json)

      if hash_from_json['found'] == true
        score_final = (answer.length * 2)
        msg = 'Well Done!'
      else
        score_final = 0
        msg = "not an english word"
      end
    end

    @score_final = score_final
    @msg = msg

  end

end
