-- pandoc-pagebreak
--
-- a pandoc lua filter for replacing horizontal rules with page breaks
--


function HorizontalRule()
    if FORMAT == "latex" then
        return pandoc.RawBlock("latex", "\\newpage\\null")
    elseif FORMAT == "context" then
        return pandoc.RawBlock("context", "\\pagebreak\\null")
    elseif string.find(FORMAT,"^html[45]?$") then
        return pandoc.RawBlock(FORMAT, '<span style="page-break-after: always" />')
    elseif string.find(FORMAT,"^epub[23]?$") then
        return pandoc.RawBlock("html5", '<span style="page-break-after: always" />')
    elseif FORMAT == "docx" then
        return pandoc.RawBlock("openxml", '<w:p><w:r><w:br w:type="page"/></w:r></w:p>')
    end
end


