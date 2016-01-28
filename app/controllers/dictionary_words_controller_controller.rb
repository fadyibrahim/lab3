require "#{Rails.root}/app/models/web_spellchecker.rb"
class DictionaryWordsControllerController < ApplicationController
  def spellcheck
    @checkedword= Hash.new(0)
    input_word = params[:term]
    webspellcheck= WebSpellchecker.new
    puts webspellcheck.correct(input_word)
    #render :text => "#{webspellcheck.correct(input_word)}"
    @checkedword["term"]=[input_word]
    @checkedword["known"]=[webspellcheck.known(input_word).any?]
    #@checkedword["suggestion"]=[WebSpellChecker.correct(input_word)]
    render json: @checkedword
  end
end
