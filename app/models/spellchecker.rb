require 'set'

class Spellchecker

  
  ALPHABET = 'abcdefghijklmnopqrstuvwxyz'

  #constructor.
  #text_file_name is the path to a local file with text to train the model (find actual words and their #frequency)
  #verbose is a flag to show traces of what's going on (useful for large files)
  def initialize(text_file_name)
    #read file text_file_name
    #extract words from string (file contents) using method 'words' below.
    #put in dictionary with their frequency (calling train! method)
    f=File.read(text_file_name)
	text = words(f) #extract words from string (file contents) using method 'words' below.
    train!(text) #put in dictionary with their frequency (calling train! method)
	
  end

  def dictionary
    #getter for instance attribute
    return @dictionary
  end
  
  #returns an array of words in the text.
  def words (text)
    return text.downcase.scan(/[a-z]+/) #find all matches of this simple regular expression
  end

  #train model (create dictionary)
  def train!(word_list)
    #create @dictionary, an attribute of type Hash mapping words to their count in the text {word => count}. Default count should be 0 (argument of Hash constructor).
    @dictionary = Hash.new(0)
    word_list.each do |word|
       @dictionary[word] += 1
       end
  end

  #lookup frequency of a word, a simple lookup in the @dictionary Hash
  def lookup(word)
     return dictionary[word]
  end
  
  #generate all correction candidates at an edit distance of 1 from the input word.
  def edits1(word)
    d=0
    deletes = Array.new

    while d < word.length 
    stringList=word.split(//)
    stringList.delete_at(d)
    stringNew="'#{stringList.join("','")}'".gsub(/[,']/,"")
    deletes.push(stringNew)
    d=d+1
    end
    #all strings obtained by deleting a letter (each letter)
    t=0
    transposes = Array.new
    
    while t < word.length-1
    tempWord=word
    templetter= word[t]
    value =tempWord.gsub(tempWord[t],tempWord[t+1])
    value[t+1]=templetter
    #tempWord.sub(tempWord[t],tempWord[t+1]).sub(tempWord[t+1],templetter)
    #tempWord.sub(tempWord[t+1],templetter)
    #tempWord[t]=tempWord[t+1]
    #tempWord[t+1]=templetter
    transposes.push(value)
    t=t +1
    end
    #all strings obtained by switching two consecutive letters
    inserts = []
        for i in 0..word.length
    	ALPHABET.each_char do |e|
           str = word.dup
           str = str.insert(i,e)
	   inserts.push(str)
	   end
	end
    # all strings obtained by inserting letters (all possible letters in all possible positions)
    r=0
    replaces=Array.new
    
    while r< word.length
		tempWord=word
		counter=0
		while counter<ALPHABET.length
			value=tempWord.gsub(tempWord[r],ALPHABET[counter])
			replaces.push(value)
			counter=counter+1
		end
		r=r+1
	end
    #all strings obtained by replacing letters (all possible letters in all possible positions)
    return (deletes + transposes + replaces + inserts).to_set.to_a #eliminate duplicates, then convert back to array
  end
  

  # find known (in dictionary) distance-2 edits of target word.
  def known_edits2 (word)
    d2 = []
    
    d1 = edits1(word)
    d1.each do |e|
   	 d2.concat(edits1(e))
    end 

    return known(d2)
    # get every possible distance - 2 edit of the input word. Return those that are in the dictionary.
  end

  #return subset of the input words (argument is an array) that are known by this dictionary
  def known(words)
  	result = words.find_all {|w| @dictionary.has_key?(w) }
  	result.empty? ? nil : result
    #find all words for which condition is true
     #you need to figure out this condition
    
  end


  # if word is known, then
  # returns [word], 
  # else if there are valid distance-1 replacements, 
  # returns distance-1 replacements sorted by descending frequency in the model
  # else if there are valid distance-2 replacements,
  # returns distance-2 replacements sorted by descending frequency in the model
  # else returns nil
  def correct(word)
  	good_words = []

	good_words = known([word])
	
	if good_words 
		if good_words.length == 1
			return good_words
		end
	end
	
	good_words = known(edits1(word))
	if !good_words
		good_words = known_edits2(word)
	end

	if good_words
		words_2 = []
		@dictionary.sort_by {|k,v| v}.reverse.each do |key, value|
			str = key.dup
			if good_words.include?(str) == true
				if words_2.include?(str) == false
					words_2.push(str)
		       		 end
			end
		end
		return words_2
	end
	return nil
  
  end
    
  
end

