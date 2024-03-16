import vdplus

options.null_value = ""

#vd.use_light_colors()
options.color_default      = 'white black'  # the default fg and bg colors
options.color_key_col      = '236 white'   # color of key columns
options.color_edit_cell    = '234 black'     # cell color to use when editing cell
options.color_selected_row = '164 magenta'  # color of selected rows
options.color_note_row     = '164 magenta'  # color of row note on left edge
options.color_note_type    = '88 red'  # color of cell note for non-str types in anytype columns
options.color_warning      = '202 11 yellow'
options.color_add_pending  = '34 green'
options.color_change_pending  = '166 yellow'
options.plot_colors = '20 red magenta black 28 88 94 99 106'

unbindkey('i')
unbindkey('gi')
bindkey('i', 'edit-cell')
bindkey('gi', 'setcol-input')
bindkey('^W', 'save-sheet')

# vi: ft=python
