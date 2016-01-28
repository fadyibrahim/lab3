# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', -> # initialize current word to an empty string.
 word = ""

 #update this line with correct selector and event
 $("#blogpost_contents").keypress (e) -> 

  # get the 1-character string that the user typed
  inp = String.fromCharCode(e.which) 

  #if this was a letter (use .match method and regular expression)
  if (inp.match(/[a-z]/i)) 
 #add letter to current word
    word += inp
  else
    if (word.match(/\w+/i)) # if the current word is a sequence of letters
      $.get window.location.origin + "/spellcheck/" + word, (data) -> 

       # console.log(data)
        if (!data.known)

          #join suggestions in a single string

          str = 'The word "' + data.term + '" is not a word, did you mean: ' + data.suggestions[0] + '?'
          $("#spellcheck").text(str)
        word = ""  #empty the word again
