-- A pandoc lua filter for list items with custom labels
-- 
-- Looks for paragraphs that begin with "@=Label" and possibly contain additional "@=Labels":
--
-- @=P1. All men are mortal.
-- @=P2. Socrates is mortal.
-- @=C.  Socrates is a man.
--
-- and converts them into lists with custom labels. 

function Split_at_Labels(table)
  local new_table = {}
  local pos = 0
  for _,value in pairs(table) do
    if value.t ==  "Str" and value.text:match("@=.*") then
      pos = pos + 1
      new_table[pos] = {}
    end
    table.insert(new_table[pos], value)
  end
  return new_table
end

Para = function(element)
  if element.content[1].text:match("@=.*") then
    local content_string = ""
    local items = Split_at_Labels(element.content)
    for _,item in pairs(items) do
      local label = table.remove(item,1).text:gsub("@=","")
      item = pandoc.utils.stringify(item)
      if FORMAT == "latex" then
        content_string = content_string .. "\\item[" .. label .. "] " ..  item
      elseif FORMAT:match("html.*") then
        content_string = content_string .. "<li style='list-style-type: \"" .. label .. " \"'>" .. item .. "</li>"
      else
        return
      end
    end
    if FORMAT == "latex" then
      return pandoc.RawInline("latex","\\begin{itemize} " .. content_string .. "\\end{itemize}")
    elseif FORMAT:match("html.*") then
      return pandoc.RawInline("html","<ul> " .. content_string .. " </ul>")
    end
  else
    return
  end
end

