-- A pandoc lua filter for generating truth table exercises

local pl = require'pl.import_into'()

local format = FORMAT or "markdown"

local function findSentenceLetters(s)
  local sentenceLetters = {"P", "Q", "R", "S", "T", "U", "V", "W"}
  local foundLetters = {}

  for _, letter in ipairs(sentenceLetters) do
      if string.find(s, letter) then
          table.insert(foundLetters, letter)
      end
  end

  return foundLetters
end


function toBits(num,bits)
    -- returns a table of bits, most significant first.
    local t = {} -- will contain the bits        
    for b = bits, 1, -1 do
        t[b] = math.fmod(num, 2)
        num = math.floor((num - t[b]) / 2)
    end
    return t
end




local function latexTruthTable(elem)
  local formatString = ""
  local headerRow = ""
  local rows = {}
  local formula = pandoc.utils.stringify(elem.content)

  -- first generate the table for the atomic sentences
  local atomicSentences = findSentenceLetters(formula)
  for _, letter in ipairs(atomicSentences) do
    formatString = formatString .. "c"
    headerRow = headerRow .. [[$\rm ]] .. letter .. [[$ & ]]
  end
  formatString = formatString .. [[@{\hspace{3pt}}|@{\hspace{3pt}}]]

  -- generate the truthvalue assignments
  local rows = {}
  local n = #atomicSentences
  local totalRows = 2^n
  for i = 0, totalRows - 1 do
    rows[i + 1] = string.gsub(string.gsub(table.concat(toBits(i,n)),"0","T & "),"1","F & ")
  end

  -- now explode the formula into table cells to complete the table
  for i = 1, pandoc.text.len(formula) do
    local char = pandoc.text.sub(formula, i, i)
    if char == " " then
      -- do nothing
    elseif char == "(" or char == ")" then
      -- spacing for parentheses
      formatString = formatString .. [[@{\hspace{-1pt}}c@{\hspace{-1pt}}]]
      headerRow = headerRow .. [[$\rm ]] .. char .. [[$ & ]]
      for i = 1, #rows do
        rows[i] = rows[i] .. [[ & ]]
      end
    elseif char == "," then
      -- spacing for commas
      formatString = formatString .. [[@{\hspace{3pt}}|@{\hspace{3pt}}]]
    elseif char == "⊢" then
      -- spacing for turnstile
      formatString = formatString .. [[@{\hspace{3pt}}|c|@{\hspace{3pt}}]]
      headerRow = headerRow .. [[$\rm \vdash$ & ]]
      for i = 1, #rows do
        rows[i] = rows[i] .. [[ \BBX & ]]
      end
    elseif char == "¬" or char == "~" then
      formatString = formatString .. "c"
      headerRow = headerRow .. [[$\rm \neg$ & ]]
      for i = 1, #rows do
        rows[i] = rows[i] .. [[ \BBX & ]]
      end

    elseif char == "→" then
      formatString = formatString .. "c"
      headerRow = headerRow .. [[$\rm \rightarrow$ & ]]
      for i = 1, #rows do
        rows[i] = rows[i] .. [[ \BBX & ]]
      end
    elseif char == "↔" then
      formatString = formatString .. "c"
      headerRow = headerRow .. [[$\rm \leftrightarrow$ & ]]
      for i = 1, #rows do
        rows[i] = rows[i] .. [[ \BBX & ]]
      end
    elseif char == "∧" or char == "&" then
      formatString = formatString .. "c"
      headerRow = headerRow .. [[$\rm \land$ & ]]
      for i = 1, #rows do
        rows[i] = rows[i] .. [[ \BBX & ]]
      end
    elseif char == "∨" then
      formatString = formatString .. "c"
      headerRow = headerRow .. [[$\rm \lor$ & ]]
      for i = 1, #rows do
        rows[i] = rows[i] .. [[ \BBX & ]]
      end
    else
      formatString = formatString .. "c"
      headerRow = headerRow .. [[$\rm ]] .. char .. [[$ & ]]
      for i = 1, #rows do
        rows[i] = rows[i] .. [[ \BBX & ]]
      end
    end
  end
  headerRow = string.sub(headerRow, 1, -3) .. [[\\]]
  for i=1, #rows do
    rows[i] = string.sub(rows[i], 1, -3) .. [[\\]]
  end

  local content = [[
\setlength{\tabcolsep}{1pt}
\renewcommand{\arraystretch}{1.4}
\begin{center}
\LARGE
\begin{tabular}]] .. "{" .. formatString .. "}\n"
  content = content .. headerRow .. "\n" .. [[ \hline ]] .. "\n"
  for i=1, #rows do
    content = content .. rows[i] .. "\n"
  end
  content = content .. [[\end{tabular}]] .. "\n" ..[[\end{center}]]
  return pandoc.RawBlock("latex",content)
end


function Div(div)
  if div.classes[1] == "tt" then
    if format:match 'latex' then
      return latexTruthTable(div)
    end
  end
end
