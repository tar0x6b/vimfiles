" # vimrc
" # EOL:LF / code:UTF-8
" # Vim script version

" # ディレクトリ定義：いろいろな処理で使うことがあるので最初に定義
let s:home_dir = expand('~')
let s:vimfiles_dir = '/vimfiles'
if has('unix')
    let s:vimfiles_dir = '/.vim'
endif
let s:rc_dir = s:home_dir . s:vimfiles_dir
if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
endif

" # dein.vim settings {
let s:dein_dir = s:rc_dir . '/bundles'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" ## dein installation check
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . s:dein_repo_dir
endif

" ## dein begin settings
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " ### .toml file
    let s:toml = s:rc_dir . '/dein.toml'
    let s:lazy_toml = s:rc_dir . '/dein_lazy.toml'

    " ### read toml and cache
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1}) " # 遅延ロード

    " ### end settings
    call dein#end()
    call dein#save_state()
endif

" ## dein plugin installation check
if dein#check_install()
    call dein#install()
endif

" ## dein plugin remove check
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
    call map(s:removed_plugins, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
endif
" # } dein.vim settings

" # colorscheme settings {
" ## Vimの背景色をターミナルの背景色と揃える (colorschemeより前に記述)
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none

if (has("termguicolors")) " # If you have vim >=8.0 or Neovim >= 0.1.5
    set termguicolors
endif

" ## デフォルトのカラースキームを事前に定義
try
    let g:lightline = { 'colorscheme': 'wombat' }
    colorscheme slate
catch
endtry

" ## tenderのカラースキームが使える場合は切り替える
if dein#tap('tender.vim')
    let g:lightline = { 'colorscheme': 'tender' }
    colorscheme tender
endif

" # } colorscheme settings

" # vim_tmp directry, swpファイル、バックアップファイル保存先 {
" 
let s:tmp_dir = s:rc_dir . '/tmp'
if !isdirectory(s:tmp_dir)
    call mkdir(s:tmp_dir, 'p')
endif
execute 'set directory=' . s:tmp_dir
execute 'set backupdir=' . s:tmp_dir
execute 'set undodir=' . s:tmp_dir

" # } vim_tmp directry, swpファイル、バックアップファイル保存先

" # viminfo ファイルの保存先
let s:viminfo_file = substitute(s:home_dir , '\' , '/' , 'g') . s:vimfiles_dir . '/viminfo'
execute 'set viminfo+=n' . s:viminfo_file
" #execute 'echo "' . s:viminfo_file . '"' "" " # 変数内用の確認用処理

" # Vimヘルプの言語 優先順位を設定
set helplang=ja,en

" # } プラグイン設定

" # 表示設定 {
set number " # 行番号を表示する
set title " # 編集中のファイル名を表示
set showmatch " # 括弧入力時の対応する括弧を表示
set wildmenu wildmode=list:full " 補完機能を有効
set laststatus=2 " # 常にステータスラインを表示項目
set statusline=%F " # ファイル名表示
set statusline+=%m " # 変更チェック表示
set statusline+=%r " # 読み込み専用かどうか表示
set statusline+=%h " # ヘルプページなら[HELP]と表示
set statusline+=%w " # プレビューウインドウなら[Prevew]と表示
set statusline+=%= " # これ以降は右寄せ表示
set statusline+=[ENC=%{&fileencoding}] " # file encoding
set statusline+=[POS=%04l:%04v][%p%%] " # カーソル位置
set wrap " # 折り返し表示
set ambiwidth=double " # 一部の２バイト文字の位置ずれ防止
set hls " # 検索時のハイライト表示を有効
set clipboard=unnamed " # ヤンク、プットするときにクリップボードを使用
set tabstop=4 " # タブ文字の表示幅を4桁
set shiftwidth=4 " # 自動インデントに使われる空白を4桁
set cmdheight=2 " # コマンドラインの高さ
set showtabline=2 " # タブページのラベルを常に表示する
set mouse=a " # マウスを使う
set tabstop=4 " # タブ幅をスペース4つ分にする
set expandtab " # tabを半角スペースで挿入する
set shiftwidth=4 " # vimが自動で生成する（読み込み時など）tab幅をスペース4つ分にする
set belloff=all " # ビープ音を消す

" ## Caffeineアプリへの対応：<F15>キーを無視する
map <F15> <Nop>
map! <F15> <Nop>
tmap <F15> <Nop>
lmap <F15> <Nop>

" ## カーソル形状
if has('vim_starting')
    " # 挿入モード時:カーソル形状を縦線で点滅状態にする
    let &t_SI .= "\e[5 q"
    " # ノーマルモード時:カーソル形状を箱型で点滅状態にする
    let &t_EI .= "\e[1 q"
    " # 置換モード時:カーソル形状を下線で点滅状態にする
    let &t_SR .= "\e[3 q"
endif

" # } 表示設定

" # 印刷設定 {

" ## ヘッダーの設定
set printheader=%m%t%=PAGE\ %N

" ## ページ余白
set printoptions=left:15mm,right:10mm,top:10mm,bottom:10mm

" ## 印刷フォント設定
set printfont=Migu\ 1M:h12

" # } 印刷設定

" # 文字エンコード、改行コード設定 {

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932
set fileformat=dos
set fileformats=dos,unix,mac

" # } 文字エンコード、改行コード設定

" # キーバインド設定 {
set backspace=indent,eol,start

" ## 選択部分をクリップボードにコピー
vmap <C-C> "+y

" ## Ctrl+Vで貼り付け => これを使うと矩形選択はCtrl+Qを使う
nmap <C-V> "+Pa<ESC>

" ## 挿入モード時、クリップボードから貼り付け
imap <C-V> <ESC>"+pa

" ## 選択部分をクリップボードの値に置き換え=ヴィジュアルモードで連続貼付
vmap <C-V> "_d"+P
vmap p "_dP

" ## コマンドライン時、クリップボードから貼り付け
cmap <C-V> <C-R>+

" ## タブ切り替え
" ### Go to next tab
nmap <C-Tab> gt
"nmap <C-l> gt
"nmap <C-k> gt

" ### Go to previous tab
nmap <C-S-Tab> gT
"nmap <C-j> gT
"nmap <C-h> gT

" # } キーバインド設定

" # vimrcの拡張
let s:extend_vimrc = s:rc_dir . '/extend/vimrc_extend'
if filereadable(expand(s:extend_vimrc))
  execute 'source ' s:extend_vimrc
endif

" #  { Power Shellをシェルに設定
"
if has('win32')
    let s:pwsh_dir = '$PROGRAMFILES/PowerShell/7/pwsh.exe'
    if !executable(expand(s:pwsh_dir))
        let s:pwsh_dir = '$USERPROFILE/scoop/apps/pwsh/current/pwsh.exe'
        if !executable(expand(s:pwsh_dir))
            let s:pwsh_dir = '$SystemRoot/System32/WindowsPowerShell/v1.0/powershell.exe'
        endif
    endif
    execute 'set shell=' . fnameescape(expand(s:pwsh_dir))
endif
" # } Power Shellをシェルに設定
