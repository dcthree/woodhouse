---
---
WOODHOUSE_INDEX = {}

normalize = (input) ->
  input.normalize().toLowerCase().trim().replace(/[-<>⸤⸥†*";.,\][_(){}&:^·\\=0-9]/g,'')

search_for = (value) ->
  console.log("searching for: #{value}")
  $('#results').empty()
  $('#results').append("<a href=\"http://artflsrv02.uchicago.edu/cgi-bin/efts/dicos/woodhouse_test.pl?keyword=#{value}\" target=\"_blank\">Search for \"#{value}\" in the University of Chicago Woodhouse</a><br/><br/>")
  normalized_value = normalize(value)
  if WOODHOUSE_INDEX[normalized_value]?
    for definition in WOODHOUSE_INDEX[normalized_value]
      $('#results').append(definition)
  else
    $('#results').append("<span>No results for \"#{value}\".</span>")

$(document).ready ->
  console.log('ready')

  Papa.parse("#{window.location.href.split("#")[0]}data/woodhouse.csv",
    {
      download: true,
      newline: "\r\n",
      worker: true,
      complete: (results) ->
        console.log("dictionary parsing complete")
        for result in results.data
          WOODHOUSE_INDEX[normalize(result[0])] ?= []
          WOODHOUSE_INDEX[normalize(result[0])].push result[1]
        console.log("index built")
        $('#search').autocomplete
          delay: 600
          minLength: 1
          source: []
          select: (event, ui) ->
            console.log(ui)
            if window.location.hash != ui.item.value
              search_for(ui.item.value)
          search: (event, ui) ->
            if window.location.hash != $('#search').val()
              search_for($('#search').val())
        $('#search').autocomplete "option", "source", (request, response) ->
          normalized_term = normalize(request.term)
          matches = Object.keys(WOODHOUSE_INDEX).filter (h) -> h.startsWith(normalized_term)
          matches = matches.sort (a,b) -> a.length - b.length
          response(matches[0..20])
        $('#search').prop('placeholder','Enter an English search term')
        $('#search').prop('disabled',false)
    }
  )
