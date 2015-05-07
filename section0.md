# Section 0 講義の前のセットアップ

## 0-1 VirtualBoxのインストール
1. OSを確認するために"dpkg --print-architecture"を実行
2. VirtualBox本体を[公式サイト](https://www.virtualbox.org/wiki/Linux_Downloads()からダウンロード
3. 依存関係の修復コマンド("sudo apt-get -f install")を実行
4. "libsdl1.2debian"パッケージをインストール
5. "sudo dpkg -i ファイル名.deb"を実行しvirtualboxをインストール
5. virtualbox コマンドを実行し動作確認

## 0-2 Vagrantのインストール
1. [Vagrantの公式サイト](http://www.vagrantup.com/downloads)から本体をダウンロード
2. "dpkg -i ファイル名.deb"を実行しインストール
3. "vagrant -v"を実行し動作確認

