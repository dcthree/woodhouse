---
---

$(document).ready ->
  console.log('ready')

  Papa.parse('data/woodhouse.csv',
    {
      download: true,
      newline: "\r\n",
      worker: true,
      complete: (results) ->
        console.log("dictionary parsing complete")
        console.log results
    }
  )
