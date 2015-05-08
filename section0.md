# Section 0 講義の前のセットアップ

## 0-1 VirtualBoxのインストール
1. OSを確認するために`dpkg --print-architecture`を実行
2. VirtualBox本体を[公式サイト](https://www.virtualbox.org/wiki/Linux_Downloads)からダウンロード
3. 依存関係の修復コマンド`sudo apt-get -f install`を実行
4. `sudo apt-get install libsdl1.2debian`を実行しパッケージをインストール
5. `sudo dpkg -i virtualbox-4.3_4.3.26-98988-Ubuntu-raring_amd64.deb`を実行しVirtualBoxをインストール
6. `virtualbox`コマンドを実行し動作確認

## 0-2 Vagrantのインストール
1. [Vagrantの公式サイト](http://www.vagrantup.com/downloads)から本体をダウンロード
2. `sudo dpkg -i vagrant_1.7.2_x86_64.deb`を実行しインストール
3. `vagrant -v`を実行し動作確認

