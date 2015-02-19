"" GENERAL SETTINGS
let mapleader = ',' " Remap leader
set shortmess=filnxtToOI " Do not show welcome message
set nobackup " Vim is not made for backups
set fo=tcq " Turn off auto adding comments on next line
filetype plugin indent on

"" PLUGINS SETUP
call plug#begin("~/.vim/plugged")
Plug 'junegunn/vim-plug'
Plug 'ap/vim-buftabline'
Plug 'scrooloose/nerdtree'
Plug 'altercation/vim-colors-solarized'
Plug 'scrooloose/syntastic'
Plug 'fatih/vim-go'
Plug 'kien/ctrlp.vim'
Plug 'mileszs/ack.vim'
Plug 'Raimondi/delimitMate'
Plug 'chase/vim-ansible-yaml'
Plug 'editorconfig/editorconfig-vim'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
call plug#end()

"" IMPORT WORK SPECIFIC CONFIGS (could also use try/catch)
let g:work_vimrc = $ADMIN_SCRIPTS . "/master.vimrc"
if filereadable(g:work_vimrc)
    silent! execute 'source ' . work_vimrc
else
    " Default configuration for intentation and tab size
    set tabstop=4
    set softtabstop=4
    set expandtab
    set smarttab
    set shiftwidth=4
    set autoindent
endif

"" PLUGINS SETTINGS
" NERDTree stuff
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 0
let g:NERDTreeHighlightCursorline = 0
nnoremap <C-n> :NERDTreeToggle<CR>
" if the last window is NERDTree, then close Vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Manual syntastic checks
let g:syntastic_mode_map = { 'mode': 'passive' }
" format with goimports instead of gofmt
let g:go_fmt_command = "goimports"
"buftabline
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1

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
set incsearch
" Settings for files tab completion
set wildmenu
set wildmode=list:longest,full
set wildignore=*.swp,*.pyc,*.tgz,*.gz,*.bz2,*.o

"" KEYBOARD MAPPINGS
" ; works like : for commands
nnoremap ; :
" Use the arrows to something usefull (switch buffer)
nnoremap <right> :bn<CR>
nnoremap <left> :bp<CR>
" Toggle paste on/off
nnoremap <leader>pp :setlocal paste!<CR>
" Hide left line numbers
nnoremap <leader>n :set number!<CR>
" Close current buffer
nnoremap <leader>d :call BufferDelete()<CR>
" Close all the buffers
nnoremap <leader>ba :1,300 bd!<CR>
" When pressing <leader>cd switch to the directory of the open buffer
nnoremap <leader>cd :cd %:p:h<CR>
" Clearing highlighted search
nnoremap <silent> <leader>/ :nohlsearch<CR>
" save as root
cnoremap w!! w !sudo tee > /dev/null "%"
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

function! BufferDelete()
    if &modified
        echohl ErrorMsg
        echomsg "No write since last change. Not closing buffer."
        echohl NONE
    else
        let s:total_nr_buffers = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))

        if s:total_nr_buffers == 1
            bdelete
            echo "Buffer deleted. Created new buffer."
        else
            bprevious
            bdelete #
            echo "Buffer deleted."
        endif
    endif
endfunction
