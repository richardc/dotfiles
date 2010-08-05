" vim: set noet nosta sw=4 ts=4 fdm=marker :
"
" TangledStrings
" Chris Jones <cmsj@tenshu.net>
"
" Simple plugin to check if the current file is managed by puppet by adding
" information to the statusbar, a la:
"
" 	set statusline=%{TangledStringsState()}
"

if exists( 'tangledstrings_loaded' )
	finish
endif
let tangledstrings_loaded = '1.0'

" }}}
" Defaults for misc settings {{{
"
if !exists( 'g:tangledstringsAlerts' )
        let g:tangledstringsAlerts = 1
endif

if !exists( 'g:tangledstringsWarnTxt' )
	let g:tangledstringsWarnTxt = "WARNING: PUPPET MANAGED FILE"
endif

if !exists( 'g:tangledstringsNormTxt' )
	let g:tangledstringsNormTxt = ""
endif

"}}}

" TangledStringsState() {{{
" Return the current buffer rev id from the global dictionary.
"
function! TangledStringsState()
	if exists( 'g:tangledstrings' )
		let l:key = expand('%:p')
		return has_key(g:tangledstrings, l:key) ? g:tangledstringsWarnTxt : g:tangledstringsNormTxt
	else
		call <SID>TangledStringsRefreshCache()
		call TangledStringsState()
	endif
endfunction


" }}}
" TangledStringsRefreshCache() {{{
"
" Populate the global dictionary with the current puppet managed files
"
function! <SID>TangledStringsRefreshCache()
	if ! exists( 'g:tangledstrings' )
		let g:tangledstrings = {}
	endif

	" Guard against existence/permissions errors
	if ! isdirectory('/var/lib/puppet/client_yaml/catalog')
		return
	endif

	" This should really be done with native VIM scripting, shelling out is ugly
	let l:filelist = system("grep -h title /var/lib/puppet/client_yaml/catalog/*.yaml | awk '{ print $2 }' | grep '^/' 2>/dev/null")
	let l:tangles = split(l:filelist, '\n')
	let l:filecount = len(l:tangles)
	let l:currentfile = bufname('%')
	let l:istangled = 0

	while l:filecount > 0
		let l:filecount = l:filecount - 1
		let l:key = l:tangles[ l:filecount ]
		let g:tangledstrings[ l:key ] = 1
	endwhile

	return
endfunction
" }}}
" TangledStringsAlert() {{{
"
" Show an alert if the current file is managed
"
function! <SID>TangledStringsAlert()
	let l:state = TangledStringsState()

	if l:state != ""
		echomsg l:state
	endif
endfunction

" }}}
" Refresh the rev for the current buffer on reads/writes. {{{
"
if g:tangledstringsAlerts == 1
	autocmd BufReadPost          * call <SID>TangledStringsAlert()
	autocmd BufFilePost          * call <SID>TangledStringsAlert()
	autocmd BufWritePost         * call <SID>TangledStringsAlert()
	autocmd BufWinEnter          * call <SID>TangledStringsAlert()
	autocmd FileReadPost         * call <SID>TangledStringsAlert()
	autocmd FileChangedShellPost * call <SID>TangledStringsAlert()
endif
" }}}

