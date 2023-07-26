" # gvimrc
" # EOL:LF / code:UTF-8
" # Vim script version

" # ウインドウに関する設定
if has('win32')
    " ## ツールバー/メニューバーの表示関連
    set guioptions-=T
    set guioptions-=m
    map <silent> <C-F2> :call GuioptionsToggle('T')<CR>
    map <silent> <C-F3> :call GuioptionsToggle('m')<CR>

    " ## メニューバーの文字化け対応
    source $VIMRUNTIME/delmenu.vim
    set langmenu=ja_jp.utf-8
    source $VIMRUNTIME/menu.vim

    winpos 0 0 " # ウィンドウ位置
    set columns=120 " # ウインドウの幅
    set lines=45 " # ウインドウの高さ
    set guifont=Migu\ 1M:h14 " # GUIフォント設定
    set renderoptions=type:directx,renmode:5
endif

" # 関数の定義
function g:GuioptionsToggle(opt)
    if 'mT' =~# a:opt
        if &guioptions =~# a:opt
            let &guioptions = substitute(&guioptions, a:opt, '', 'g')
        else
            let &guioptions = &guioptions . a:opt
        endif
    endif
endfunction
