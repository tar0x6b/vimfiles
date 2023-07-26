# vimfiles
## 概要
Windows+PowershellでVimを使う設定と手順。  
※vimrcはLinuxでも動作確認済み。  
※個人用として作成したが、vimrc等が誰かの参考になるならと思い公開しておきます。

## 目次
- Vimのインストール
- Gitのインストール
- vimfilesフォルダをUSERPROFILEにクローン
- 環境変数設定
- GitでインストールしたVimを使うための設定
- コンテキストメニューにVimを表示する
- Vimの試起動

## Vimのインストール
- `winget install --id vim.vim -e -s winget -i`
9.0.0412で確認
  - インストーラー→コンポーネント選択画面で
    - 「VIMのアイコンを作成」→「デスクトップ上」のチェックを外す
    - 「VIMのコンテキストメニューを追加」のチェックを外す
    - 「既定のコンフィグを作成」のチェックを外す
    - 「プラグインディレクトリを作成」のチェックを外す
- インストールを進め、最後の「インストール完了後にREADMEを表示する」のチェックを外す

## Gitのインストール
- `winget install --id Git.Git -e -s winget -i`
2.37.3で確認
  - 「Windows Exlplorer Integration」のチェックを外してNext
  - 「Don't create a Start Menu folder」のチェックを入れてNext
- インストールを進め、最後の「View Releas Notes」のチェックを外す
- 一旦、gitのpath設定を有効にするため Restart-Computer

## Git設定とvimfilesフォルダをUSERPROFILEにクローン
Power Shellで以下のコマンドを実行する
```
git config --global user.name tar
git config --global user.email 6558964+tar0x6b@users.noreply.github.com
git config --global init.defaultBranch main
git config --global core.editor vim
git config --global core.pager "LESSCHARSET=utf-8 less"
git config --global core.autocrlf input
git config --global alias.a add
git config --global alias.c commit
git config --global alias.s status
git config --global alias.b branch
git config --global alias.sw switch
git config --global alias.l "log --graph --oneline --decorate=short -20 --date=short --format='%C(yellow)%h%C(reset) %C(cyan)%ad%C(reset)%C(auto)%d%C(reset) %s %C(bold blue)@%an%C(reset)'"
git clone https://github.com/tar0x6b/vimfiles.git $env:USERPROFILE\vimfiles
git config --global commit.template ~/vimfiles/gitconfig/.commit_template
```
一旦Powershellをexit  
Linuxの場合は`git clone`等のクローン先を`.vim`に変える
```
git clone https://github.com/tar0x6b/vimfiles.git ~/.vim
git config --global commit.template ~/.vim/gitconfig/.commit_template
```
## 環境変数設定
管理者のPower Shellで以下のコマンドを実行する
```
[Environment]::SetEnvironmentVariable('VIM_DIR', 'C:\Program Files\Vim\vim90', [System.EnvironmentVariableTarget]::Machine)
$PATH = [Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::User).TrimEnd(';')
$add_path1 = '%VIM_DIR%'
$add_path2 = '%USERPROFILE%\bin\cmd'
$add_path3 = '%USERPROFILE%\bin\ffmpeg\bin'
$add_pathx = $PATH+';'+$add_path1+';'+$add_path2+';'+$add_path3
setx PATH $add_pathx
[Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME', "$($env:USERPROFILE)\config", [System.EnvironmentVariableTarget]::User)
```
一旦 Restart-Computer

## GitでインストールしたVimを使うための設定
管理者のPower Shellで以下のコマンドを実行する
```
ren 'C:\Program Files\Git\usr\bin\vim.exe' vim.exe.disabled
```

## コンテキストメニューにVimを表示する
管理者のPower Shellで以下のコマンドを実行する
```
New-Item 'HKLM:\SOFTWARE\Classes\*\shell\Vim\Command' -force
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\Vim\Command' -name '(default)' -Value '%VIM_DIR%\gvim.exe -p --remote-tab-silent "%1"' -propertyType ExpandString -force
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\Vim' -name 'Icon' -Value '%VIM_DIR%\gvim.exe' -propertyType ExpandString -force
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\Vim' -name 'MUIVerb' -Value 'Edit with Vim(&X)' -propertyType String -force
```

## Vimの試起動
- Vimを起動し、プラグインのDLを待つ
- プラグインの動作チェックと:messageの確認
- 一旦Vimを起動し直し、fzfを起動してDLする

以上
