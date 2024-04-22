-- pandoc-pagenumbers
--
-- a pandoc lua filter for retaining inserting page numbers into text 
--

function Span(inline)
    page = inline.attr.identifier
    if string.find(page, "^page_[0-9ivx][0-9ivx]*$") then
        page = string.gsub(page, "page_", "")
        insert = pandoc.Str("[" .. page .. "]") 
        -- table.insert(inline.content, 1, insert)
        -- return inline
        return insert
    end
end



