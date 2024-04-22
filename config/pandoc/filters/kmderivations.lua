local format = FORMAT or "html"


local function convertDer(original)
    local output = pandoc.pipe("kmder.lua", { format }, original)
    return output
end

local function convertLogic(original, f)
    local output = pandoc.pipe("kmsym.lua", { f }, original)
    return output
end

function CodeBlock(block)
    if block.classes[1] == "derivation" or block.classes[1] == "kmd" then
        local original = block.text
        local output = convertDer(original)
        if format == "html" or 
            format == "html5" or 
            format == "latex" or 
            format == "tex" or 
            format == "markdown" then
            return pandoc.RawBlock(format, output)
        elseif format == "plain" then
            return pandoc.Plain(output)
        end
    end
   if block.classes[1] == "logic" or block.classes[1] == "l" then
       if format == "markdown" then
           local original = block.text
           local output = convertLogic(original, "utf")
           local classes = { "l" }
           return pandoc.CodeBlock(output, pandoc.Attr("",classes,{}))
       else
            local original = block.text
            local output =  convertLogic(original, "latex") 
            return pandoc.Math("DisplayMath", output)
       end
   end
end

function Code(inline)
   -- if inline.classes[1] == "logic" or inline.classes[1] == "l" then
   if format == "markdown" then
       local original = inline.text
       local output = convertLogic(original, "utf")
       local classes = { "l" }
       return pandoc.Code(output, pandoc.Attr("",classes,{}))
   else
        local original = inline.text
        local output = convertLogic(original, "latex")
        return pandoc.Math("InlineMath", output)
   end
   -- end
end


