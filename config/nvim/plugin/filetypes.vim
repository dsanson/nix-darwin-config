"""""""""""""""""""""
" Filetype Tweaks
"""""""""""""""""""""

" open PDFs in external viewer
au BufRead *.pdf sil exe "!open " . shellescape(expand("%:p")) | bd | let &ft=&ft | redraw!

" set up syntax highlighting for e-mail
au BufRead,BufNewFile .followup,.article,.letter,/tmp/pico*,nn.*,snd.*,/tmp/mutt* :set ft=mail

" bibtex tweaks
au Filetype bib set nowrap

" open contents of epub and htmlz files
au BufReadCmd   *.epub      call zip#Browse(expand("<amatch>"))
au BufReadCmd   *.htmlz      call zip#Browse(expand("<amatch>"))

" pandoc
au Filetype markdown set filetype=markdown.pandoc
au FileType carnap set filetype=markdown.pandoc.carnap
