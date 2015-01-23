" Bundles {{{
set nocompatible
" filetype has to be off for Vundle
filetype off
" Set our RunTime Path
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
" Custom colortheme
Bundle 'FlashYoshi/bubblegum'
" nginx highlighting
Bundle 'nginx.vim'
" Git diff in the sign collumn
Bundle 'airblade/vim-gitgutter'
" Set indentation rule per filetype
filetype plugin indent on
" }}}
" Leader {{{
" Set the leader
let mapleader=','
let maplocalleader=','
" Leader+leader opens NERDTree
nnoremap <leader><leader> :NERDTreeToggle<esc>
"nmap <leader>nt :NERDTree<cr>
" Makes leader+p open insert in pastemode
set pastetoggle=<leader>p
" }}}
" Plugin settings {{{
" Let NERDTree ignore some files
let NERDTreeIgnore = ['\.pyc$', '\.hi', '\.o']
" }}}
" General options {{{
set number
" Enable ruler (bottom right in statusbar)
set ruler
" Remember indent on new line
set autoindent
set encoding=utf-8
" Allow decent backspacing: remove indents, linebreaks,...
set backspace=indent,eol,start
" Disable modelines: file dependent vim settings
set modelines=0
" Always show the statusbar
set laststatus=2
" Show executing command on last line
" i.e. no. of selected lines in Visual mode
set showcmd
if v:version > 703
  set undofile
  set undoreload=10000
  set undodir=~/.vim/tmp/undo/     " undo files
endif
" Open new buffers on the right side i.e. :vnew
set splitright
" Open new buffers on below the current i.e. :new
set splitbelow
" Auto reload file on change
set autoread
" Keep 8 lines below/above cursor
set scrolloff=8
" }}}
" Colorscheme {{{
set t_Co=256
" Enable syntax highlighting
syntax enable
colorscheme bubblegum
" }}}
" Wrapping {{{
" Don't wrap lines
set nowrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
" Insert spaces instead of tabs
set expandtab
" Show tabs and traling spaces
set list
set listchars=tab:\ \ ,trail:·

function! s:setupWrapping()
  setlocal wrap
  setlocal wrapmargin=4
  setlocal textwidth=80
  if v:version > 703
    setlocal colorcolumn=+1
  endif
endfunction
" }}}
" Searching and movement {{{
" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

set hlsearch
" Search whilst typing
set incsearch
" ignorecase and smartcase together:
" ignore if no case in query
" case sensitive if case in query
set ignorecase
set smartcase
" Briefly jump to matched brace when we insert one
set showmatch
" }}}
" Backups and undo {{{
" Backups
set backupdir=~/.vim/tmp/backup/
" Swap files
set directory=~/.vim/tmp/swap/
" Enable backups
set backup
set backupskip=/tmp/*,/private/tmp/*"
" }}}
" Folding {{{
set foldlevelstart=0

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 4 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . ' ' . repeat(" ",fillcharcount) . ' ' . foldedlinecount . ' '
endfunction " }}}
set foldtext=MyFoldText()
" }}}
" Filetype specific {{{
" Markdown {{{

augroup ft_markdown
  au!

  au BufNewFile,BufRead *.m*down setlocal filetype=markdown
  au BufNewFile,BufRead *.md setlocal filetype=markdown
  au Filetype markdown call s:setupWrapping()

  " Use <localleader>1/2/3 to add headings.
  au Filetype markdown nnoremap <buffer> <localleader>1 yypVr=
  au Filetype markdown nnoremap <buffer> <localleader>2 yypVr-
  au Filetype markdown nnoremap <buffer> <localleader>3 I### <ESC>
augroup END
" }}}
" C# {{{
augroup c_sharp
  au!
  au Filetype cs setlocal ts=4 sw=4 sts=4
augroup END
" }}}
" C {{{
augroup c_lang
  au!
  au Filetype cpp setlocal ts=4 sw=4 sts=4
  au Filetype c setlocal ts=4 sw=4 sts=4
augroup END
" }}}
" Haskell {{{
augroup haskell
  au!
  au Filetype haskell setlocal ts=4 sw=4 sts=4
  au FileType haskell setlocal omnifunc=necoghc#omnifunc
augroup END
" }}}
" Java {{{
augroup java
  au!
  au Filetype java setlocal ts=4 sw=4 sts=4

augroup END
" }}}
" Latex {{{
augroup ft_latex
  au!

  au Filetype tex call s:setupWrapping()
  au Filetype tex setlocal spell

augroup END
" }}}
" Python {{{
augroup ft_python
  au!

  au FileType python setlocal ts=4 sw=4 sts=4

augroup END
" }}}
" Ruby {{{
augroup ft_ruby
  au!

  au FileType ruby call s:setupWrapping()

augroup END
" }}}
" Nginx {{{
augroup ft_nginx
  au!

  au FileType nginx setlocal ts=4 sts=4 sw=4

augroup END
" }}}
" }}}
" Mappings {{{
" Rewrite file with sudo
cmap w!! w !sudo tee % >/dev/null
" }}}
" Autocommands {{{
" Auto fold on opening file
au BufRead {.vimrc,vimrc} set foldmethod=marker
au BufRead /etc/nginx/* set ft=nginx
" }}}
" Sync clipboard
if has ('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
end
