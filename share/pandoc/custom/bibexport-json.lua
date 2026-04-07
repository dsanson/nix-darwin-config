local citation_ids = {}
local source = PANDOC_STATE.input_files[1]

local function strip_ext(name)
  if not name then return nil end
  return name:match("^(.*)%.[^%.]+$") or name
end

local bibout = os.getenv("BIBOUT") or nil
if bibout == nil then
  bibout = strip_ext(source) .. '.json'
end

function Doc(body, meta, vars)
  local citations = {};
  for cid, _ in pairs(citation_ids) do
    citations[#citations + 1] = '"' .. cid .. '"'
  end
  cites = table.concat(citations, ',')
  os.execute('cat "' .. meta.bibliography .. 
    '" | jq \'map(select(.id == (' .. 
    cites .. '))) ' ..
    '| map(del(.abstract, .accessed, .file, ."open-in-zotero", .tags)) ' ..
    '| map(select((.URL // "") | test("^zotero://") | not))' ..
    '\'' ..
    ' > ' .. bibout)
  return 'Output written to ' .. bibout
end

function Cite(c, cs)
  for i = 1, #cs do citation_ids[cs[i].citationId] = true end
  return ''
end

function Str(s) return s end
setmetatable(_G, {__index = function() return function() return "" end end})  

