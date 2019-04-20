set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Colors
Plugin 'dracula/vim'

" Utils
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'epmatsw/ag.vim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-rhubarb'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-bundler'
Plugin 'janko-m/vim-test'
Plugin 'thoughtbot/vim-rspec'
Plugin 'majutsushi/tagbar'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'christoomey/vim-tmux-runner'
Plugin 'craigemery/vim-autotag'
Plugin 'jiangmiao/auto-pairs'
Plugin 'simeji/winresizer'
Plugin 'junegunn/fzf.vim'
Plugin 'mattn/emmet-vim'
Plugin 'elixir-editors/vim-elixir'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'edkolev/tmuxline.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'godlygeek/tabular'
Plugin 'vim-syntastic/syntastic'
Plugin 'gosukiwi/vim-atom-dark'
Plugin 'sonph/onehalf'
Plugin 'ngmy/vim-rubocop'
Plugin 'wincent/command-t'
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'junegunn/vim-easy-align'
"
Plugin 'tpope/vim-rbenv'
Plugin 'tmm1/ripper-tags'
" w0rp/ale linting for Vim
"mkdir -p ~/.vim/pack/git-plugins/start
"git clone https://github.com/w0rp/ale.git ~/.vim/pack/git-plugins/start/ale

call vundle#end()
filetype plugin indent on

" Syntax
syntax on
set t_Co=256
set background=dark
"colorscheme dracula
"colorscheme onehalfdark

" Map Leader
let mapleader = ","

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 0
let g:jsx_ext_required = 0

let g:airline_theme='luna' " luna
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

runtime macros/matchit.vim

set number
set backspace=indent,eol,start
set clipboard=unnamed
set incsearch
set hlsearch
set ignorecase
set tags=tags;/
set noswapfile
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set ttymouse=xterm2
set mouse=a
set nowrap
set hidden
set history=10000
set scrolloff=4
set noesckeys
set ttimeout
set ttimeoutlen=1
set relativenumber
set path=$PWD/**

" Exclude included files with vim autocomplete
set complete-=i

" Key Mappings
nmap <leader>vr :tabe $MYVIMRC<cr>
nmap <leader>rv :source $MYVIMRC<cr>

cnoremap %% <C-R>=expand('%:h').'/'<cr>
nmap <space>e :edit %%
nmap <space>v :view %%

" Window
nnoremap <leader>1 <C-w>_<cr>
nnoremap <leader>2 <C-w>\|<cr>
nnoremap <leader>3 <C-w>=<cr>

" Reload page
nmap <C-a> :e!<cr>
imap <C-a> :e!<cr>

" Bash
nmap <space>z :!
imap <space>z :!

" Find and replace in file
nmap <space>F :%s/<c-r><c-w>//g<left><left>

" Open PR in Github from Git Blame
nmap <space>G :Gbrowse <c-r><c-w><cr>

" Debuggers
imap cll console.log();<Esc>==f(a
nmap cll yiwocll
imap ppp binding.pry
nmap ppp yiwoppp
imap dgr debugger
nmap dgr yiwodgr
imap iee IEx.pry
nmap iee yiwoiee

" Deleting
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP

" Search directory
nnoremap <leader>ta :ta<SPACE>
nnoremap <leader>tb :TagbarToggle<CR>
nnoremap <leader><space> :noh<CR>
nnoremap <leader>x :only<CR>
cnoremap <C-a> <C-b>
map \ :NERDTreeToggle<CR>
map \| :NERDTreeFind<CR>
map <leader>m :CommandTMRU<CR>
map <leader>rt :!~/.vim/bin/update_ctags 2>/dev/null &<CR>
map <leader>g :Gblame<CR>
nmap <space>b <c-^>
nmap <space>w :w<cr>
nmap <space>q :q!<cr>
nmap <leader>q :wq<cr>
nmap <leader>w :set wrap!<cr>
map <space><tab> :Tabularize /
map <leader>p :pu<cr>
nmap 0 ^
nmap <space>f gg=G<cr>``<cr>
nmap <leader>fh :%s/:\(\w\+\)\s*=>\s*/\1: /g<CR>
nmap <leader>fs :%s/'/"/g<cr>
nmap <leader>fS :%s/"/'/g<cr>

" Move lines
nnoremap <leader>vv :m .+1<CR>==
nnoremap <leader>ff :m .-2<CR>==
inoremap <leader>vv <Esc>:m .+1<CR>==gi
inoremap <leader>ff <Esc>:m .-2<CR>==gi
vnoremap <leader>vv :m '>+1<CR>gv=gv
vnoremap <leader>ff :m '<-2<CR>gv=gv
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" Open bundler
nmap <leader>bs :Bsplit<cr>

" Open in GitHub
nmap <leader>G :Gbrowse master:%<cr>

" Open PR in Github from Git Blame
nmap <space>G :Gbrowse <c-r><c-w><cr>

" Open routes
nmap <leader>br :e config/routes.rb<cr>

" Sort
vnoremap <leader>S :sort<cr>

" Split windows
map <leader>- :split<cr>
map <leader>\ :vsplit<cr>

" Prettier
map <leader>p :PrettierAsync<cr>

autocmd BufWritePre * :%s/\s\+$//e
autocmd VimResized * :wincmd =
au VimEnter * highlight clear SignColumn
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" Rename Current File
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

" Promote Variable to Rspec Let
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>l :PromoteToLet<cr>

" Open up file to last cursor position
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

" Fix Multiple cursors lag in change mode
function! Multiple_cursors_before()
  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
  endif
endfunction

function! Multiple_cursors_after()
  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
  endif
endfunction

" Italics
hi htmlArg gui=italic
hi Comment gui=italic
hi Type    gui=italic
hi htmlArg cterm=italic
hi Comment cterm=italic
hi Type    cterm=italic

" Vim easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)"

" Specs
"let g:rspec_command = "Dispatch docker-compose exec test bundle exec spring rspec {spec}"
let g:rspec_command = "Dispatch bundle exec spring rspec {spec}"
nmap <space>T :w<cr>:call RunCurrentSpecFile()<CR>
nmap <space>t :w<cr>:call RunNearestSpec()<CR>
nmap <space>l :call RunLastSpec()<CR>
nmap <space>A :call RunAllSpecs()<CR>

set wildignore+=*/node_modules/*
set wildignore+=*/bower_components/*"

" Navigation
map <leader>jj :CommandT<CR>
map <leader>ja :CommandT app<CR>
map <leader>jm :CommandT app/models<CR>
map <leader>jc :CommandT app/controllers<CR>
map <leader>jv :CommandT app/views<CR>
map <leader>jh :CommandT app/helpers<CR>
map <leader>js :CommandT app/services<CR>
map <leader>jw :CommandT app/workers<CR>
map <leader>jr :CommandT app/javascript_apps/<CR>
map <leader>je :CommandT app/services/distribution_system<CR>
map <leader>jl :CommandT lib<CR>
map <leader>jp :CommandT public<CR>
map <leader>jt :CommandT spec<CR>
map <leader>jC :CommandT config<CR>
map <leader>jD :CommandT db<CR>
map <leader>jf :CommandT spec/support/factories<CR>
map <leader>jd :CommandT %%<CR>

map <leader>aa :Ag! -i <c-r>=expand("<cword>")<cr><cr>
map <leader>sa :Ag! -i <c-r>=expand("<cword>")<cr> app/<cr>
map <leader>sm :Ag! -i <c-r>=expand("<cword>")<cr> app/models<cr>
map <leader>sc :Ag! -i <c-r>=expand("<cword>")<cr> app/controllers<cr>
map <leader>sv :Ag! -i <c-r>=expand("<cword>")<cr> app/views<cr>
map <leader>sh :Ag! -i <c-r>=expand("<cword>")<cr> app/helpers<cr>
map <leader>ss :Ag! -i <c-r>=expand("<cword>")<cr> app/services<cr>
map <leader>sw :Ag! -i <c-r>=expand("<cword>")<cr> app/workers<cr>
map <leader>sr :Ag! -i <c-r>=expand("<cword>")<cr> app/javascript_apps/<cr>
map <leader>se :Ag! -i <c-r>=expand("<cword>")<cr> app/services/distribution_system<cr>
map <leader>sl :Ag! -i <c-r>=expand("<cword>")<cr> lib/<cr>
map <leader>sp :Ag! -i <c-r>=expand("<cword>")<cr> public/<cr>
map <leader>st :Ag! -i <c-r>=expand("<cword>")<cr> spec/<cr>
map <leader>sC :Ag! -i <c-r>=expand("<cword>")<cr> config/<cr>
map <leader>sD :Ag! -i <c-r>=expand("<cword>")<cr> db/<cr>
map <leader>sf :Ag! -i <c-r>=expand("<cword>")<cr> spec/support/factories<cr>
map <leader>sd :Ag! -i <c-r>=expand("<cword>")<cr> %%<cr>

map <space>aa :Ag! -i<space>
map <space>sa :Ag! -i <space>app/<C-Left><Left>
map <space>sm :Ag! -i <space>app/models/<C-Left><Left>
map <space>sc :Ag! -i <space>app/controllers/<C-Left><Left>
map <space>sv :Ag! -i <space>app/views/<C-Left><Left>
map <space>sh :Ag! -i <space>app/helpers/<C-Left><Left>
map <space>ss :Ag! -i <space>app/services/<C-Left><Left>
map <space>sw :Ag! -i <space>app/workers/<C-Left><Left>
map <space>sr :Ag! -i <space>app/javascript_apps/<C-Left><Left>
map <space>se :Ag! -i <space>app/services/distribution_system<C-Left><Left>
map <space>sl :Ag! -i <space>lib/<C-Left><Left>
map <space>sp :Ag! -i <space>public/<C-Left><Left>
map <space>st :Ag! -i <space>spec/<C-Left><Left>
map <space>sC :Ag! -i <space>config/<C-Left><Left>
map <space>sD :Ag! -i <space>db/<C-Left><Left>
map <space>sf :Ag! -i <space>spec/support/factories/<C-Left><Left>
map <space>sd :Ag! -i <space>%%<C-Left><Left>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
