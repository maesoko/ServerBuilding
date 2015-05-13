# Section 1 基本のサーバー構築

## 1-1 CentOS 7のインストール
### VirtualBoxにCentOS7 64bit用の仮想マシンを作成
1. 「Oracle VM VirtualBox マネージャー」の「新規」ボタンをクリックします。
2. 「名前とオペレーティングシステム」画面で以下の設定を行い、「次」ボタンをクリックします。
 * 名前：任意の名前を入力 (私は「CentOS7」と入力)
 * タイプ：「Linux」を選択
 * バージョン：「Ubuntu (64 bit)」を選択
3. 「メモリーサイズ」画面で仮想マシンに割り当てるメモリの容量を指定し、「次へ」ボタンをクリックします。 
 * 1024MBを指定
4. 「ハードドライブ」画面で「仮想ハードドライブを作成する」を選択し、「作成」ボタンをクリックします。
5. 「ハードドライブのファイルタイプ」画面で「VDI (VirtualBox Disk Image)」を選択し、「次へ」ボタンをクリックします。
6. 「物理ハードドライブにあるストレージ」画面で「可変サイズ」を選択し、「次へ」をクリックします。
7. 「ファイルの場所とサイズ」画面で新しい仮想ハードドライブファイルの名前と仮想ハードドライブのサイズを指定し、「作成」ボタンをクリックします。
 * 新しい仮想ハードドライブファイルの名前は、デフォルトで入力されている「名前とオペレーティングシステム」画面で入力した仮想マシンの名前「CentOS7」をそのまま使用。
 * 仮想ハードドライブのサイズに8.00GBを指定。

### ネットワークの設定
1. VirtualBoxマネージャーのメニューにある「環境設定」をクリックします。
2. 設定画面が表示されるので、ネットワークをクリックし、右側にあるネットワークカードの上に+が表示されているアイコンをクリックします。
3. vboxnet0というホストオンリーネットワークのアダプタが追加されるのでOKボタンを押します。
4. 「Oracle VM VirtualBox マネージャー」で作成された仮想マシンを選択して、「設定」ボタンをクリックします。
5. 設定画面で「ネットワーク」を選択し、「アダプター2」の設定画面を開き、以下の設定を行い、「OK」ボタンをクリックします。
 * ネットワークアダプターを有効化：チェックを入れる
 * 割り当て：「ホストオンリーアダプター」を選択
 * 名前：「vboxnet0」を選択

### VirtualBoxへのインストール
作成した仮想マシンにOSのインストールメディアを読み込ませて、OSのインストールを行えるようにします。
ここではCentOS7 64bitをインストールするためにインストールメディア「CentOS-7-x86_64-Minimal-1503-01.iso」を使用しています。

1. 「Oracle VM VirtualBox マネージャー」で作成された仮想マシンを選択して、「設定」ボタンをクリックします。
2. 設定画面で「ストレージ」を選択し、「ストレージツリー」から「コントローラー:IDE」の配下にある「空」を選択し、「属性」の「CD/DVDドライブ」の右にあるCDのアイコンをクリックし、「仮想CD/DVDディスクファイルの選択...」を選択します。
3. ファイル選択ダイアログで「CentOS-7-x86_64-Minimal-1503-01.iso」ファイルを選択すると、「ストレージ」設定画面の「ストレージツリー」の「コントローラー:IDE」の配下にあった「空」のところに選択したISOファイルが設定されるので、「OK」ボタンをクリックします。
4. 「Oracle VM VirtualBox マネージャー」で作成された仮想マシンを選択して、起動ボタンをクリックするとCentOS7 64bitのインストーラーが起動します。
5. 「Install CentOS7」を選択しインストールを開始
6. インストール時に使用する言語に「日本語」を選択し「続行」をクリック。
7. 「インストールの概要」で「インストールの開始」をクリックします。
8. インストール中に、root以外の作業用(管理者)のユーザーを作成します。
 * フルネーム:「administrator」
 * ユーザー名:「administrator」
 * ユーザーを管理者にする:チェックを入れる
 * このアカウントを使用する場合にパスワードを必要とする:チェックを入れる
 * パスワードを設定をします。
10. rootパスワードをクリックしパスワードの設定をします。
11. rootパスワードの設定が完了し、作業用（管理者）ユーザーの作成が完了したらインストールが終了したら右下の「設定完了」をクリックします。
12. 「再起動」をクリックします。
13. 再起動後、ログインします。
 * localhost login: 「administrator」
 * password: 8で設定したパスワード

### ネットワークアダプター1/2へのIPアドレスの設定とssh接続の確認
インストールしたCentOSのネットワークの設定を行います。
ネットワークインターフェイスの設定ファイル「/etc/sysconfig/network-scripts/ifcfg-enp0s?」をnmcliコマンドを使用して編集していきます。

1. 以下のコマンドを実行して、ネットワークの接続が自動で行われるようにします。
 * `nmcli connection modify enp0s3 connection.autoconnect yes`
 * `nmcli connection modify enp0s8 connection.autoconnect yes`

### SSH接続の確認
1. 以下のコマンドを実行し接続を確認
 * `ssh administrator@192.168.56.101`

### インストール後の設定
yumやwgetを使用する時のproxyの設定を行います。

1. vimで「/etc/profile」を開きます。
2. 最終行に以下を追記 

  MY_PROXY_URL="http://172.16.40.1:8888"

  HTTP_PROXY=$MY_PROXY_URL

  HTTPS_PROXY=$MY_PROXY_URL

  FTP_PROXY=$MY_PROXY_URL

  http_proxy=$MY_PROXY_URL

  https_proxy=$MY_PROXY_URL

  ftp_proxy=$MY_PROXY_URL

  export HTTP_PROXY HTTPS_PROXY FTP_PROXY http_proxy https_proxy ftp_proxy

3. `source /etc/profile`を実行
4. vimで「/etc/yum.conf」を開きます。
5. 最終行に以下を追加

  proxy=http://172.16.40.1:8888
6. vimで「~/.wgetrc」を開きます。
7. 最終行に以下を追記

  http_proxy = http://172.16.40.1:8888

  https_proxy = http://172.16.40.1:8888

  ftp_proxy = http://172.16.40.1:8888

### アップデート
1. `sudo yum update`を実行
2. wgetをyumでインストール
 * `sudo yum install wget`
3. `wget https://www.google.co.jp/`を実行し「index.html」がダウロードできることを確認

## 1-2 Wordpressを動かす(1)
Wordpressを動作させるのに必要なソフトウェアをインストールしていきます。

1. sshで仮想マシンに接続する

 `ssh administrator@192.168.56.101`

### Apacheのインストール
1. 次のコマンドを実行しApacheをインストールする
  * `sudo yum -y install httpd`
2. インストールできたことを確認するため、以下のコマンドも実行
 * `httpd -v`

### MySQLのインストール
1. 次のコマンドを実行しMySQLのリポジトリを追加します。
 * `sudo yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm`
2. リポジトリを追加できたら、MySQL Community Server をインストールします。
 * `sudo yum -y install mysql-community-server`
3. インストールできたことを確認するため、以下のコマンドを実行しバージョンを確認
 * `mysqld --version`

### PHPのインストール
1. 次のコマンドを実行しPHPをインストール
 * `sudo yum -y install php php-mysql`
2. インストールできたことを確認するため、次のコマンドを実行しバージョンを表示
 * `php --version`

### サーバーの起動
LAMP環境に必要なソフトウェアがインストールできたので、インストールしたそれぞれのサーバーを起動します。

1. サーバーを再起動しても起動時に自動的にサーバーが起動するように設定。
 * `sudo systemctl enable httpd.service`
 * `sudo systemctl enable mysqld.service`
2. サーバーを起動します。
 * `sudo systemctl start httpd.service`
 * `sudo systemctl start mysqld.service`
3. サーバーが起動できているかどうかを確認します。
 * `systemctl is-active httpd.service`
 * `systemctl is-active mysqld.service`

### データベースとユーザーを作成
1. mysqlにログインします。
 * `mysql -u root -p`
2. データベースを作成します

  `mysql>CREATE DATABASE db_wordpress;`  
  `mysql>GRANT ALL PRIVILEGES ON db_wordpress.* TO s13012_wordpress@localhost IDENTIFIED BY "pw_wordpress";`  
  `mysql>FLUSH PRIVILEGES;`  
  `mysql>EXIT`  

  * データベース名:db_wordpress
  * ユーザー名:s13012_wordpress
  * ユーザパスワード:pw_wordpress

### Wordpressの初期設定
1. Wordpressをダウンロード・解凍します。
 * `wget https://ja.wordpress.org/wordpress-4.2.2-ja.tar.gz`
 * `tar -xzvf wordpress-4.2.2-ja.tar.gz`
2. 解凍後、公開ディレクトリにファイルを移動
 * `sudo mv wordpress /var/www/html/`
3. Wordpress設定ファイルを作成
 * `cd /var/www/html/wordpress`
 * `sudo cp wp-config-sample.php wp-config.php`
 * `sudo vi wp-config.php`
4. MySQLに作成したデータベース名、ユーザー、パスワードを設定
 * define('DB_NAME', 'database_name_here'); -> define('DB_NAME', 'db_wordpress);
 * define('DB_USER', 'username_here'); -> define('DB_USER', 's13012_wordpress');
 * define('DB_PASSWORD', 'password_here'); -> define('DB_PASSWORD', 'pw_wordpress');
5. ユニークキーを設定

  　[オンラインジェネレータ](https://api.wordpress.org/secret-key/1.1/salt/)を使用してユニークキーを設定していきます。

  define('AUTH_KEY',         'put your unique phrase here');  
  define('SECURE_AUTH_KEY',  'put your unique phrase here');  
  define('LOGGED_IN_KEY',    'put your unique phrase here');  
  define('NONCE_KEY',        'put your unique phrase here');  
  define('AUTH_SALT',        'put your unique phrase here');  
  define('SECURE_AUTH_SALT', 'put your unique phrase here');  
  define('LOGGED_IN_SALT',   'put your unique phrase here');  
  define('NONCE_SALT',       'put your unique phrase here');  
  ⇣⇣  
  define('AUTH_KEY',         '?ztGNkFX*d.~.O}6[V+piklE<@^Ot2dYc>u$+S>H#r?_ASw!fQ,li=INn9q*G-v8');  
  define('SECURE_AUTH_KEY',  'zFH=tr+W~K>~f4Lv+3W|*P+IJ|b2FvAGyZ;$9,SCPezDn.rgT$b74~U1 pvB6G5\`');  
  define('LOGGED_IN_KEY',    ';6J/qpq_UOA2`5]|f+i|c9Sj3Rv`#Vz@|IJ&UW(Y!35a|k<40|$D#geo6SeF_VK7');  
  define('NONCE_KEY',        '_]>[TIG.o*bwc[2-Z Dx.0w&QE:{4d1pWY*uB;4r*GK?6vgI^)[J,v_.6lJ,vc6_');  
  define('AUTH_SALT',        '$||&[e#]-4#E*{-iKJEa>lTV^p#kuq!|ta-H,2{^JFu7e}Q+aAmGvd$796o}oCr>');  
  define('SECURE_AUTH_SALT', 'w]1Gj?</AHT3Uj,y7#1UJG-!saz@c2-NK}*XFVVx]/)cR+P%>^&Nb;vosC7wb2|r');  
define('LOGGED_IN_SALT',   'Z-X/g9@1r2k[A]?USFL=!xwHaSTH(;RiG=Z/h|--kTRP5O(: m|>yPjJ<Q@ryQ{U');  
  define('NONCE_SALT',       'Ur3&C:&SVGTSl63HJvBX?QK{Y{NES$4t4DkDJ#noKjxOHYl0QY$<{}uXm3Z6r=*f');  

### UbuntuからCentOS上のWordpressを開くための設定

1. CentOSのファイアウォールを無効にします。
 * `sudo systemctl disable firewall.service`
2. SELinuxを無効にします。
 * `vi /etc/selinux/config`
 * `SELINUX=enforcing -> SELINUX=disable`

### Wordpressのインストール
1. ブラウザ上から`http://192.168.56.101/wordpress/wp-admin/install.php`にアクセス
2. 必要情報を入力していきます。
 * サイトのタイトル:s13012_WeSite
 * ユーザー名:s13012
 * パスワード:password
 * メールアドレス:s13012@std.it-college.ac.jp
 * 検索エンジンによるサイトのインデックスを許可する:チェックを入れる
3. 「WordPressをインストール」をクリックします。
4. 「ログイン」ボタンをクリックし管理画面を開きます。
