-- A pandoc lua filter for generating truth table exercises

local pl = require'pl.import_into'()

function Div(div)
  if div.classes[1] == "note" then
    return
  end
end
