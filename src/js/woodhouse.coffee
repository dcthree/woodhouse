---
---
WOODHOUSE_INDEX = {}
ABBREVIATIONS = {
"absol.": "Absolutely",
"acc.": "Accusative",
"act.": "Active",
"adj.": "Adjective",
"adv.": "Adverb",
"Æsch.": "Æschylus",
"Andoc.": "Andocides",
"aor.": "Aorist",
"Ar.": "Aristophanes",
"Arist.": "Aristotle",
"conj.": "Conjunction",
"cp.": "Compare",
"dat.": "Dative",
"Dem.": "Demosthenes",
"Eur.": "Euripides",
"fem.": "Feminine",
"frag.": "Fragment",
"fut.": "Future",
"gen.": "Genitive",
"Hdt.": "Herodotus",
"imperf.": "Imperfect",
"indic.": "Indicative",
"infin.": "Infinitive",
"interj.": "Interjection",
"intrans.": "Intransitive",
"Isae.": "Isaeus",
"Isoc.": "Isocrates",
"lit.": "Literally",
"Lys.": "Lysias, Aristophane's Lysistrata, or Plato's Lysis",
"masc.": "Masculine",
"met.": "Metaphorically",
"Met.": "Metaphorically",
"mid.": "Middle",
"neut.": "Neuter",
"opt.": "Optative",
"P.": "Prose",
"part.": "Participle",
"perf.": "Perfect",
"pl.": "Plural",
"Plat.": "Plato",
"prep.": "Preposition",
"pres.": "Present",
"pro.": "Pronoun",
"sing.": "Singular",
"Soph.": "Sophocles, or Plato's Sophista",
"subj.": "Subjunctive",
"subs.": "Substantive",
"Thuc.": "Thucydides",
"V.": "Verse",
"v.": "Verb",
"v. trans.": "Verb transitive",
"v. intrans.": "Verb intransitive",
"voc.": "Vocative",
"Xen.": "Xenophon",
"Ag.": "Agamemnon",
"Choe.": "Choephoroe",
"Eum.": "Eumenides",
"Pers.": "Persae",
"P. V.": "Prometheus Vinctus",
"Supp.": "Supplices",
"Theb.": "Septem Contra Thebas",
"Ach.": "Acharnians",
"Αv.": "Aves",
"Eccl.": "Ecclesiazusae",
"Eq.": "Equites",
"Nub.": "Nubes",
"Pl.": "Plutus",
"Ran.": "Ranae",
"Thesm.": "Thesmophoriazusae",
"Vesp.": "Vespae",
"Alc.": "Alcestis",
"And.": "Andromache",
"Bacc.": "Bacchae",
"Cycl.": "Cyclops",
"El.": "Electra",
"Неc.": "Hecuba",
"Hel.": "Helen",
"Heracl.": "Heraclidae",
"H. E.": "Hercules Furens",
"Hipp.": "Hippolytus",
"I. A.": "Iphigenia in Aulis",
"I. Τ.": "Iphigenia in Tauris",
"Med.": "Medea",
"Or.": "Orestes",
"Phoen.": "Phoenissae",
"Rhes.": "Rhesus",
"Supp.": "Supplices",
"Tro.": "Troades",
"Aj.": "Ajax",
"Ant.": "Antigone",
"El.": "Electra",
"O. C.": "Œdipus Coloneus",
"O. R.": "Œdipus Rex",
"Phil.": "Sophocles' Philoctetes, or Plato's Philebus",
"Trach.": "Trachiniae",
"Ap.": "Apology",
"Alc. I.": "Alcibiades I",
"Alc. II.": "Alcibiades II",
"Charm.": "Charmides",
"Crat.": "Cratylus",
"Criti.": "Critias",
"Euth.": "Euthyphro",
"Euthy.": "Euthydemus",
"Gorg.": "Gorgias",
"Hipp. Maj.": "Hippias Major",
"Hipp. Min.": "Hippias Minor",
"Lach.": "Laches",
"Legg.": "Leges",
"Men.": "Meno",
"Parm.": "Parmenides",
"Phaedr.": "Phaedrus",
"Pol.": "Politicus",
"Prot.": "Protagoras",
"Rep.": "Republic",
"Symp.": "Symposium",
"Theaet.": "Theaetetus",
"Tim.": "Timaeus"
}

normalize = (input) ->
  input.normalize().toLowerCase().trim() # .replace(/[-<>⸤⸥†*";.,\][_(){}&:^·\\=0-9]/g,'')

search_for = (value) ->
  window.location = "##{value}"
  console.log("searching for: #{value}")
  $('#results').empty()
  $('#results').append("<a href=\"http://artflsrv02.uchicago.edu/cgi-bin/efts/dicos/woodhouse_test.pl?keyword=#{value}\" target=\"_blank\">Search for \"#{value}\" in the University of Chicago Woodhouse</a><br/><br/>")
  normalized_value = normalize(value)
  if WOODHOUSE_INDEX[normalized_value]?
    for definition in WOODHOUSE_INDEX[normalized_value]
      $('#results').append(definition)
    $('#results span').each (index, element) ->
      if ($(this).attr('style') == 'color:brown') or ($(this).attr('style') == 'color:darkviolet')
        if ABBREVIATIONS[$(this).text()]?
          $(this).prop('title', ABBREVIATIONS[$(this).text()])
        else
          console.log "No abbreviation lookup for #{$(this).text()}"
    $('#results i').each (index, element) ->
      if this.previousSibling? and (this.previousSibling.nodeValue.match(/(see|under) $/i))
        word_links = ("<a href=\"##{see_word.replace('.','').trim()}\"><i>#{see_word}</i></a>" for see_word in $(this).text().split(','))
        $(this).replaceWith(word_links.join(','))
  else
    $('#results').append("<span>No results for \"#{value}\".</span>")

search_for_hash = ->
  hash_parameter = decodeURI(window.location.hash.substr(1))
  console.log 'got hash parameter:', hash_parameter
  $('#search').val(hash_parameter)
  search_for(hash_parameter)

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
        window.addEventListener('hashchange', search_for_hash, false)
        if window.location.hash?.length
          search_for_hash()
    }
  )
