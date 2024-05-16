-- A pandoc lua filter for managing different versions in a single
-- document.
--
-- usage: 
--    pandoc --lua-filter pandoc-questions.lua --metadata=version:<version>
--    pandoc --lua-filter pandoc-questions.lua -o output-<version>.pdf
--
-- <version> can be set using metadata or inferred from the name of the
-- the output file (metadata overrides output file).

local pl = require'pl.import_into'()

local format = FORMAT or "markdown"
local vars = {}
local version = nil
local shufflelists = false

-- improve seeding on these platforms by throwing away the high part of time, 
-- then reversing the digits so the least significant part makes the biggest change
-- NOTE this should not be considered a replacement for using a stronger random function
-- ~ferrix
math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )

function shuffle(array)
    -- fisher-yates
    local output = { }
    local random = math.random
    for index = 1, #array do
        local offset = index - 1
        local value = array[index]
        local randomIndex = offset*random()
        local flooredIndex = randomIndex - randomIndex%1

        if flooredIndex == offset then
            output[#output + 1] = value
        else
            output[#output + 1] = output[flooredIndex + 1]
            output[flooredIndex + 1] = value
        end
    end
    return output
end

function get_meta(meta)
    if meta["version"] then
      version = meta["version"]
      -- version = version[1]["text"]
      print(version)
    elseif PANDOC_STATE.output_file and string.match(PANDOC_STATE.output_file, ".*%-(.-)%.") then
      version = string.match(PANDOC_STATE.output_file, ".*%-(.-)%.")
      meta["version"] = version
    end
    if version == "nil" then
      version = nil
    end
    if meta["shuffle-lists"] then
      shufflelists = true
    end
    if version == "1" then
      meta["versionmark"] = pandoc.MetaString('ا')
    elseif version == "2" then
      meta["versionmark"] = pandoc.MetaString('ب')
    elseif version == "3" then
      meta["versionmark"] = pandoc.MetaString('ت')
    elseif version == "4" then
      meta["versionmark"] = pandoc.MetaString('ث')
    elseif version == "5" then
      meta["versionmark"] = pandoc.MetaString('ج')
    elseif version == "6" then
      meta["versionmark"] = pandoc.MetaString('ح')
    elseif version == "7" then
      meta["versionmark"] = pandoc.MetaString('خ')
    elseif version == "8" then
      meta["versionmark"] = pandoc.MetaString('ظ')
    end
    return meta
end

function version_is_in_tag(t, v)
    match = false
    if t ~= nil then
        -- remove surrounding brackets if present
        t = string.gsub(t,"^%[([^]]*)%]$","%1")
        for w in string.gmatch(t, "%w+") do      
            if w == v then
                match = true
            end
        end
    end
    return match
end

local count = 1
function filter_ordered_lists(list)
    if version then
        local t = {}
        local a = list.listAttributes
        if list.style == "Example" then
            a.start = count
        end
        local shufflethislist = shufflelists
        for _, v in pairs(list.content) do
            local versionTag = pandoc.utils.stringify(v[1].content[1])
            if string.match(versionTag, "^%[.*%]$") then
                if version == "all" or version_is_in_tag(versionTag, version) then
                    table.remove(v[1].content,1)
                    table.remove(v[1].content,1)
                    table.insert(t,v)
                    if list.style == "Example" then
                        count = count + 1
                    end
                end
            else
                table.insert(t,v)
                if list.style == "Example" then
                    count = count + 1
                end
            end
        end
        if shufflethislist then
            t = shuffle(t)
        end
        return pandoc.OrderedList(t,a)
    end
end

function filter_bullet_lists(list)
    if version then
        local t = {}
        for _, v in pairs(list.content) do
            local versionTag = pandoc.utils.stringify(v[1].content[1])
            if string.match(versionTag, "^%[.*%]$") then
                if version == "all" or version_is_in_tag(versionTag, version) then
                    table.remove(v[1].content,1)
                    table.remove(v[1].content,1)
                    table.insert(t,v)
                end
            else
                table.insert(t,v)
            end
        end
        return pandoc.BulletList(t)
    end
end

function filter_definition_lists(list)
    if version then
        local t = {}
        for _, v in pairs(list.content) do
             local versionTag = pandoc.utils.stringify(v[2][1][1].content[1])
            if string.match(versionTag, "^%[.*%]$") then
                if version == "all" or version_is_in_tag(versionTag, version) then
                    table.remove(v[2][1][1].content,1)
                    table.remove(v[2][1][1].content,1)
                    table.insert(t,v)
                end
            else
                table.insert(t,v)
            end
        end
        return pandoc.DefinitionList(t)
    end
end

function filter_spans(span)
    if version then
        if span.attributes.v or span.attributes.version then
            if version_is_in_tag(span.attributes.v, version) 
               or version_is_in_tag(span.attributes.version, version)
               or version == "all" then
                return span
            else
                return pandoc.Span("")
            end
        else
            return span
        end
    end
end

function filter_code(code)
    if version then
        if code.attributes.v or code.attributes.version then
            if version_is_in_tag(code.attributes.v, version) 
               or version_is_in_tag(code.attributes.version, version)
               or version == "all" then
                return code
            else
                return pandoc.Span("")
            end
        else
            return code
        end
    end
end

function filter_images(image)
    if version then
        if image.attributes.v or image.attributes.version then
            if version_is_in_tag(image.attributes.v, version) 
               or version_is_in_tag(image.attributes.version, version)
               or version == "all" then
                return image
            else
                return pandoc.Span("")
            end
        else
            return image
        end
    end
end

function filter_links(link)
    if version then
        if link.attributes.v or link.attributes.version then
            if version_is_in_tag(link.attributes.v, version) 
               or version_is_in_tag(link.attributes.version, version)
               or version == "all" then
                return link
            else
                return pandoc.Span("")
            end
        else
            return link
        end
    end
end

function filter_divs(div)
    if version then
        if div.attributes.v or div.attributes.version then
            if version_is_in_tag(div.attributes.v, version) 
               or version_is_in_tag(div.attributes.version, version)
               or version == "all" then
                return div
            else
                return pandoc.Span("")
            end
        else
            return div
        end
    end
end

function filter_codeblocks(codeblock)
    if version then
        if codeblock.attributes.v or codeblock.attributes.version then
            if version_is_in_tag(codeblock.attributes.v, version) 
               or version_is_in_tag(codeblock.attributes.version, version)
               or version == "all" then
                return codeblock
            else
                return pandoc.Span("")
            end
        else
            return codeblock
        end
    end
end

function filter_headers(header)
    if version then
        if header.attributes.v or header.attributes.version then
            if version_is_in_tag(header.attributes.v, version) 
               or version_is_in_tag(header.attributes.version, version)
               or version == "all" then
                return header
            else
                return pandoc.Span("")
            end
        else
            return header
        end
    end
end


return {{Meta = get_meta}, 
        {OrderedList = filter_ordered_lists},
        {BulletList = filter_bullet_lists},
        {DefinitionList = filter_definition_lists},
        {Span = filter_spans},
        {Code = filter_code},
        {Image = filter_images},
        {Link = filter_links},
        {Div = filter_divs},
        {CodeBlock = filter_codeblocks},
        {Header = filter_headers}}
