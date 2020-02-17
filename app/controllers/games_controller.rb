require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def gen_grid(num)
    a = []
    num.times { a << ('A'..'Z').to_a.sample }
    a
  end

  def using_grid?(word, grid)
    w = word.upcase.chars
    return false unless w.all? { |l| grid.include?(l) }

    a = true
    gh = Hash.new(0)
    wh = Hash.new(0)
    grid.each { |l| gh[l] += 1 }
    w.each { |l| wh[l] += 1 }
    wh.each { |k, v| a = false unless v <= gh[k] }
    a
  end

  def new
    @letters = gen_grid(9)
  end

  def score
    @grid = params[:letters].chars
    @word = params[:word]
    @answer = 0
    @answer = 1 unless using_grid?(@word, @grid)
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = open(url).read
    valid = JSON.parse(user_serialized)['found']
    @answer = 2 unless valid
  end
end
