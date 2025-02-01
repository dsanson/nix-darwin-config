#import vdplus

options.null_value = ""

options.theme = "asciimono"

TableSheet.unbindkey('i')
TableSheet.unbindkey('gi')
TableSheet.bindkey('i', 'edit-cell')
TableSheet.bindkey('gi', 'setcol-input')
TableSheet.bindkey('^W', 'save-sheet')

# vi: ft=python
