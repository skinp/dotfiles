"" GENERAL SETTINGS
let mapleader = ',' " Remap leader
set shortmess=filnxtToOI " Do not show welcome message
set nobackup " Vim is not made for backups
set fo=tcq " Turn off auto adding comments on next line

"" VUNDLE SETUP
filetype off " Required for Vundle
set rtp +=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'vundle'
Bundle 'techlivezheng/vim-plugin-minibufexpl'
Bundle 'scrooloose/nerdtree'
Bundle 'altercation/vim-colors-solarized'
Bundle 'scrooloose/syntastic'
filetype plugin indent on

"" IMPORT FB SPECIFIC CONFIGS (could also use try/catch)
let fb_vimrc = $ADMIN_SCRIPTS . "/master.vimrc"
if filereadable(g:fb_vimrc)
  silent! execute 'source ' . fb_vimrc
endif

"" PLUGINS SETTINGS
" NERDTree stuff
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 0
let g:NERDTreeHighlightCursorline = 0
map <C-n> :NERDTreeToggle<CR>
" if the last window is NERDTree, then close Vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Mini Buf Explorer stuff
let g:miniBufExplBRSplit = 0
let g:miniBufExplHideWhenDiff = 0
let g:miniBufExplShowBufNumbers = 0
" Manual syntastic checks
let g:syntastic_mode_map = { 'mode': 'passive' }

"" BUFFERS/VIM INTERNALS SETTINGS
set hi=500 " Remember last 500 typed commands
set hidden " Do not save modified buffers before switching...
set autoread " Set to auto read when a file is changed from the outside
set switchbuf=useopen " Open buffers do not load in new window

"" WINDOWS MANAGEMENT/CREATING
set noequalalways " Make all windows the same size when adding/removing windows
set splitbelow " A new window is put below the current one
set splitright " A new window is right of the current one
set winheight=1 " Minimal number of lines used for the current window
set winminheight=0 " Minimal number of lines used for any window

"" VISUAL/COLOR/INTERFACE SETTINGS
syntax on
set background=dark
silent! colorscheme solarized
set visualbell " Visual bell on errors
set number " Show line numbers
" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=darkgreen guibg=darkgreen
match BadWhitespace /\s\+$/ " Trailing spaces are BAD
highlight LongLine ctermbg=black guibg=black
" Highlight stuff >80 char. colorcolumn is vim 7.3+ only
if exists('+colorcolumn')
    set colorcolumn=80
else
    au BufWinEnter * let w:m2=matchadd('LongLine', '\%>80v.\+', -1)
endif

"" EDITING SETTINGS
set gdefault " by default, add g to :s substitute
set backspace=eol,start,indent " Backspace deletes all

"" TEXT AND FILE SEARCH SETTINGS
" Make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase
" Settings for files tab completion
set wildmenu
set wildmode=list:longest,full
set wildignore=*.swp,*.pyc,*.tgz,*.tar.gz,*.bz2,*.o

"" KEYBOARD MAPPINGS
" ; works like : for commands
nnoremap ; :
" Use the arrows to something usefull (switch buffer)
map <right> :bn<CR>
map <left> :bp<CR>
" Toggle paste on/off
map <leader>pp :setlocal paste!<CR>
" Hide left line numbers
map <leader>n :set number!<CR>
" Close all the buffers
map <leader>ba :1,300 bd!<CR>
" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<CR>
" Clearing highlighted search
nmap <silent> <leader>/ :nohlsearch<CR>
" save as root
ca w!! w !sudo tee > /dev/null "%"
" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk
" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

"" FILETYPE SETTINGS
" Disable automatic insert of comment on newline
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Python files are always unix and utf-8
au BufNewFile *.py setlocal fileformat=unix encoding=utf-8
" Removes trailing whitespace on every save of python files
au BufWritePre *.py :call Fix_Trailing_Whitespace()
" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py match BadWhitespace /^\t\+/

"" FUNCTIONS
function! Fix_Trailing_Whitespace()
    %s/\s\+$//e
endfunction
