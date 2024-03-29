-- for now, see plugin/filetypes.vim
-- """""""""""""""""""""
-- " Filetype Tweaks
-- """""""""""""""""""""
--
-- " open PDFs in external viewer
-- au BufRead *.pdf sil exe "!open " . shellescape(expand("%:p")) | bd | let &ft=&ft | redraw!
--
-- " set up syntax highlighting for e-mail
-- au BufRead,BufNewFile .followup,.article,.letter,/tmp/pico*,nn.*,snd.*,/tmp/mutt* :set ft=mail
--
-- " bibtex tweaks
-- au Filetype bib set nowrap
--
-- " open contents of epub and htmlz files
-- au BufReadCmd   *.epub      call zip#Browse(expand("<amatch>"))
-- au BufReadCmd   *.htmlz      call zip#Browse(expand("<amatch>"))
--
--
-- " carnap
-- au FileType carnap set filetype=carnap.pandoc
-- "au Filetype carnap.pandoc :set equalprg=pandoc\ -t\ markdown\ --columns\ 78\ --atx-headers\ --id-prefix\ (random)\ --reference-location\ block\ --lua-filter=carnap.lua
-- au Filetype carnap.pandoc :set equalprg=pandoc\ --columns\ 78\ --markdown-headings=atx\ --id-prefix\ (random)\ --reference-location\ block\ --lua-filter=carnap.lua\ -f\ markdown+raw_html-raw_attribute\ -t\ markdown+raw_html-raw_attribute
