-- this is a filter for pretty printing articles
-- from the stanford encyclopedia of philosophy

hblocks = {}
meta = {}

function Div(el)
    if el.identifier == "pubinfo" or
       el.identifier == "preamble" or
       el.identifier == "main-text" or
       -- el.identifier == "bibliography" then
       el.identifier == "ppbib" then
        table.insert(hblocks, el) 
    end
end

function Meta(m)
    m.author = m['citation_title']
    m.title = m['citation_author']
    m.date = m['citation_publication_date']
    m.pagestyle = 'headings'
    m.subtitle = '(Stanford Encyclopedia of Philosophy)'
    m['margin-left'] = '1.25in'
    m['margin-right'] = '1.25in'
    m['margin-top'] = '1in'
    m['margin-bottom'] = '1in'
    m['mainfont'] = 'Minion Pro'
    m['sansfont'] = 'Myriad Pro'
    m['monofont'] = 'Inconsolata'
    m['mathfont'] = 'Neo Euler'
    meta = m
end

function Pandoc(doc)
    return pandoc.Pandoc(hblocks, meta)
end
