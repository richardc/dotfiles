" vim, not vi
set nocompatible


" always treat things as utf-8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8


" enable pathogen
call pathogen#infect()

filetype plugin indent on

let g:Gitv_OpenHorizontal = 1

let g:CSApprox_verbose_level = 0

" always show a status bar
set laststatus=2
" and put line,column in it
set ruler

" don't fold by default
set foldlevel=99
au FileType git set nofoldenable

syntax on
set background=dark
colorscheme vividchalk

if has("gui_running")
      set guioptions-=T       " no toolbar
      set cursorline          " show the cursor line
end


" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" register filetypes
au! BufRead,BufNewFile *.haml                   setfiletype haml
au! BufRead,BufNewFile *.pp                     setfiletype puppet
au! BufRead,BufNewFile *.markdown,*.mkd,*.md    setfiletype markdown
au! BufRead,BufNewFile */vhosts.d/*.conf        setfiletype apache
au! BufRead,BufNewFile */apache/**/*.conf       setfiletype apache
au! BufRead,BufNewFile *.json                   setfiletype javascript

" edge resistance when scrolling
set scrolloff=2

set showmode

" when entering a brace flash its pair
set showmatch


" some emacs-like bindings from vimacs, should help muscle memory
" http://github.com/andrep/vimacs/blob/master/plugin/vimacs.vim
nnoremap <C-x><C-c> :confirm qall<CR>
nnoremap <C-x><C-f> :edit<Space>
nnoremap <C-x><C-s> :update<CR>

nnoremap <C-x>2 <C-w>s
nnoremap <C-x>3 <C-w>v
nnoremap <C-x>0 <C-w>c
nnoremap <C-x>1 <C-w>o
nnoremap <C-x>o <C-w>w

nnoremap <C-x>b     :BufExplorer<cR>
nnoremap <C-x><C-b> :buffers<CR>
nnoremap <C-x>k     :bdelete<Space>

nnoremap <C-x><C-n> :bnext<CR>
nnoremap <C-x><C-p> :bprev<CR>
nnoremap <C-x>n     :bnext<CR>
nnoremap <C-x>p     :bprev<CR>

" enable gundo - http://sjl.bitbucket.org/gundo.vim/
nnoremap <F5> :GundoToggle<CR>
map <leader>g :GundoToggle<CR>

" From here to the end is kludged stolen sections from Smyler's config
" http://www.stripey.com/vim/vimrc.html

" * User Interface

" have command-line completion <Tab> (for filenames, help topics, option names)
" first list the available options and complete the longest common part, then
" have further <Tab>s cycle through the possibilities:
set wildmode=list:longest,full

" use "[RO]" for "[readonly]" to save space in the message line:
set shortmess+=r

" display the current mode and partially-typed commands in the status line:
set showmode
set showcmd

" have the mouse enabled all the time:
"set mouse=a

" when using list, keep tabs at their full width and display `arrows':
"execute 'set listchars+=tab:' . nr2char(187) . nr2char(183)
" (Character 187 is a right double-chevron, and 183 a mid-dot.)

" * Text Formatting -- General

set wrap

" use indents of 4 spaces, and have them copied down lines:
set shiftwidth=4
set shiftround
set autoindent
set tabstop=8

set expandtab

" normally don't automatically format `text' as it is typed, IE only do this
" with comments, at 79 characters:
set formatoptions-=t
set textwidth=79

" * Text Formatting -- Specific File Formats
" in human-language files, automatically format everything at 72 chars:
"
autocmd FileType mail,human set formatoptions+=t textwidth=72 nonumber

" for C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang set cindent

" for actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c set formatoptions+=ro

" for Perl programming, have things in braces indenting themselves:
autocmd FileType perl set smartindent

" for CSS, also have things in braces indented:
autocmd FileType css set smartindent

" for HTML, generally format text, but if a long line has been created leave it
" alone when editing:
autocmd FileType html set formatoptions+=tl

" for both CSS and HTML, use genuine tab characters for indentation, to make
" files a few bytes smaller:
autocmd FileType html,css set noexpandtab tabstop=2

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8

" * Search & Replace

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" show the `best match so far' as search strings are typed:
set incsearch

" and highlight everything the search matches
set hlsearch

" * Keystrokes -- Moving Around

" have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

" page down with <Space> (like in `Lynx', `Mutt', `Pine', `Netscape Navigator',
" `SLRN', `Less', and `More'); page up with - (like in `Lynx', `Mutt', `Pine'),
" or <BkSpc> (like in `Netscape Navigator'):
noremap <Space> <PageDown>
noremap <BS> <PageUp>
noremap - <PageUp>
" [<Space> by default is like l, <BkSpc> like h, and - like k.]


" have % bounce between angled brackets, as well as t'other kinds:
set matchpairs+=<:>

" have <F1> prompt for a help topic, rather than displaying the introduction
" page, and have it do this from any mode:
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>


" * Keystrokes -- Insert Mode

" allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

