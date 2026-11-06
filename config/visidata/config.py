#import vdplus

options.null_value = ""
options.theme = "asciimono"
options.quitguard = "true"

TableSheet.unbindkey('i')
TableSheet.unbindkey('gi')
TableSheet.bindkey('i', 'edit-cell')
TableSheet.bindkey('gi', 'setcol-input')
TableSheet.bindkey('Ctrl+W', 'save-sheet-really')

# vi: ft=python
