" vim, not vi
set nocompatible
filetype off

" manual install step:
"   mkdir -p ~/.vim/bundle
"   git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"   vim +PluginInstall +all
"
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim' " required - self-manage Vundle
Plugin 'tpope/vim-vividchalk'
Plugin 'vim-airline/vim-airline'

Plugin 'tpope/vim-git'
Plugin 'tpope/vim-fugitive'

Plugin 'vim-syntastic/syntastic'
Plugin 'google/vim-searchindex'

Plugin 'jlanzarotta/bufexplorer'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'


" Language-specific plugins
Plugin 'rodjek/vim-puppet'
Plugin 'hashivim/vim-terraform'
Plugin 'hashivim/vim-vagrant'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-rails'
Plugin 'dag/vim-fish'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on

" always treat things as utf-8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8

let g:Gitv_OpenHorizontal = 1

let g:CSApprox_verbose_level = 0

" put gundo on the right, and patch below
let g:gundo_right = 1
let g:gundo_preview_bottom = 1

" minibufexpl
let g:miniBufExplSplitBelow=1           " show at the bottom
let g:miniBufExplMapWindowNavVim=1      " C-[hjkl] navigates windows
let g:miniBufExplMapWindowNavArrows=1   " C-{Left,Right,Up,Down} navigates windows
let g:miniBufExplMapCTabSwitchBufs=1    " C-TAB cycles buffers
let g:miniBufExplUseSingleClick=1       " single click to switch

" taglist
let g:tlist_puppet_settings = 'puppet;d:definition'
nnoremap <F9> :TlistToggle<CR>

" NERDTree
map <C-n> :NERDTreeToggle<CR>
" exit if NERDTree is the last buffer open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" syntastic
" open a location list with syntax highlighters
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=5
" don't check if we're quitting
let g:syntastic_check_on_wq=0
" use mri and rubocop to validate ruby
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_puppet_puppetlint_args='--no-80chars-check'
" syntax check on file open
"let g:syntastic_check_on_open=1

" always show a status bar
set laststatus=2

" airline - a fancy status bar
" https://github.com/bling/vim-airline/
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" use unicode symbols for airline
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'


" interact with tmux - as we move between buffers set the OCS title
if &term == "screen-256color"
    set t_ts=]2;
    set t_fs=[\

    autocmd BufEnter * let &titlestring = "vim " . expand("%:t")
    set title
endif

" don't fold by default
set foldlevel=99
au FileType git set nofoldenable

syntax on
set background=dark
colorscheme vividchalk

if has("gui_running")
    set guioptions-=T       " no toolbar
    set cursorline          " show the cursor line
    "set guifont=Monaco:h12  " monaco 12
    set guifont=Liberation\ Mono\ 11
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

" when entering a brace flash its pair
set showmatch

" take longer to enter mapped key sequences
set timeoutlen=3000

" bind <C-x> to nothing so when I dither over the emacs bindings it doesn't do
" the 'decrement number at cursor' default
nnoremap <C-x> <Nop>

" some emacs-like bindings from vimacs, should help muscle memory
" http://github.com/andrep/vimacs/blob/master/plugin/vimacs.vim
nnoremap <C-x><C-c> :qa<CR>
nnoremap <C-x><C-f> :edit<Space>
nnoremap <C-x><C-s> :update<CR>

nnoremap <C-x>2 <C-w>s
nnoremap <C-x>3 <C-w>v
nnoremap <C-x>0 <C-w>c
nnoremap <C-x>1 <C-w>o
nnoremap <C-x>o <C-w>w

nnoremap <C-x>b     :CtrlPBuffer<CR>
nnoremap <C-x><C-b> :BufExplorer<CR>
nnoremap <C-x>k     :bdelete<Space>

nnoremap <C-x><C-n> :bnext<CR>
nnoremap <C-x><C-p> :bprev<CR>
nnoremap <C-x>n     :bnext<CR>
nnoremap <C-x>p     :bprev<CR>

" enable gundo - http://sjl.bitbucket.org/gundo.vim/
nnoremap <F5> :GundoToggle<CR>
map <leader>g :GundoToggle<CR>

" Add  these  lines  to  your  .vimrc  and  you  will  be   happy   with
" p5-Text-Autoformat. Use ctrl-k to reformat a paragraph and  ctrl-n  to
" reformat all text from the cursor.

imap <C-K> <esc> !G perl -MText::Autoformat -e "{autoformat;}"<cr>
nmap <C-K>       !G perl -MText::Autoformat -e "{autoformat;}"<cr>
vmap <C-K>       !G perl -MText::Autoformat -e "{autoformat;}"<cr>


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

" let Dean win, in puppet manifests use 2-space indents
autocmd FileType puppet set shiftwidth=2

autocmd FileType yaml set shiftwidth=2

" for ruby too.  Will just need a bigger font
autocmd FileType ruby set shiftwidth=2

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

