class WebSpellchecker < Spellchecker
  def initialize
  end

  def known(words)
  #result = DictionaryWord.where(word).order(count: :asc)
  DictionaryWord.where('word in ( :words)',words: words).order(count: :desc).pluck(:word)
  end


  
end
