# Section 2 その他のWebサーバー環境

## 2-1 Vagrantを使用したCentOS 7環境の起動

### Vagrantで起動できるCentOS 7のイメージを登録
1. 事前に取得したboxファイルを登録します
 * `vagrant box add CentOS7 取得したファイルのパス --force`

### Vagrantの初期設定
1. 作業用ディレクトリを作成します
 * `mkdir -p ~/ServerBuilding/CentOS7`
2. 作成したディレクトリの中で初期設定を行います。
 * `vagrant init`
3. 作成された”Vagrantfile”をvimで開き、設定を書き換えてCentOS6.5が起動するようにします。
```
　config.vm.box = "base"
```
⇣⇣⇣⇣⇣⇣⇣⇣
```
　config.vm.box = "CentOS7"
```

### 仮想マシンの起動
　`vagrant up`

### 仮想マシンの停止
　`vagrant halt`

### 仮想マシンの一時停止
　`vagrant suspend`

### 仮想マシンの破棄
　`vagrant destroy`

### 仮想マシンへ接続
　仮想マシンへsshで接続します。

　`vagrant ssh`

### ホストオンリーアダプターの設定
　サーバーを設定したあと、動作確認するために接続するためのIPアドレスを設定します。 また、そのためのNICを追加します。
```
　config.vm.box = "CentOS7"
```
の下に
```
config.vm.network "private_network", ip:"192.168.56.130"
```
を書き加えます。

### Vagrantfileの反映
変更した設定を反映させるために以下を実行
 * `vagrant reload`

## 2-2 Wordpressを動かす(2)
1-2ではWordpressをApache + PHP + MySQLで動作させたが、今度はNginx + PHP + MariaDBで動作させます。

### プロキシの設定
yumやwgetを使用する時のproxyの設定を行います。

1. vimで「/etc/profile」を開きます。
2. 最終行に以下を追記 
```
MY_PROXY_URL="http://172.16.40.1:8888"
HTTP_PROXY=$MY_PROXY_URL
HTTPS_PROXY=$MY_PROXY_URL
FTP_PROXY=$MY_PROXY_URL
http_proxy=$MY_PROXY_URL
https_proxy=$MY_PROXY_URL
ftp_proxy=$MY_PROXY_URL
export HTTP_PROXY HTTPS_PROXY FTP_PROXY http_proxy https_proxy ftp_proxy
```
3. `source /etc/profile`を実行
4. vimで「/etc/yum.conf」を開きます。
5. 最終行に以下を追加
```
proxy=http://172.16.40.1:8888
```
6. vimで「~/.wgetrc」を開きます。
7. 最終行に以下を追記
```
http_proxy = http://172.16.40.1:8888
https_proxy = http://172.16.40.1:8888
ftp_proxy = http://172.16.40.1:8888
```

### wgetのインストール
 * `sudo yum install wget`

### Nginxのインストール
1. Nginxの[公式サイト](http://nginx.org/en/linux_packages.html#stable)からリポジトリ追加用のrpmをダウンロードします。
 * `wget http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm`
2. Nginxのリポジトリを追加
 * `sudo yum -y install nginx-release-centos-7-0.el7.ngx.noarch.rpm`
3. Nginxをyumでインストール
 * `sudo yum install nginx`
4. Nginxを有効にして起動します
 * `sudo systemctl enable nginx.service`
 * `sudo systemctl start nginx.service`

### php-fpmをインストール
1. yumでphp-fpmをインストール
 * `sudo yum install php-fpm php-mbstring php-mysql`
2. nginxの設定でphp-fpmが動くように変更する
```
sudo vi /etc/nginx/conf.d/default.conf
```
以下のように編集

```
server {
listen       80;
server_name  localhost;

#charset koi8-r;
#access_log  /var/log/nginx/log/host.access.log  main;

location / {
root   /usr/share/nginx/wordpress;
index  index.html index.htm index.php;
}

#error_page  404              /404.html;

# redirect server error pages to the static page /50x.html
#
error_page   500 502 503 504  /50x.html;
location = /50x.html {
root   /usr/share/nginx/html;
}

# proxy the PHP scripts to Apache listening on 127.0.0.1:80
#
#location ~ \.php$ {
#    proxy_pass   http://127.0.0.1;
#}

# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
#
location ~ \.php$ {
root           /usr/share/nginx/wordpress;
fastcgi_pass   127.0.0.1:9000;
fastcgi_index  index.php;
fastcgi_param  SCRIPT_FILENAME  /usr/share/nginx/wordpress$fastcgi_script_name;
include        fastcgi_params;
}

# deny access to .htaccess files, if Apache's document root
# concurs with nginx's one
#
#location ~ /\.ht {
#    deny  all;
#}
}
```
```
sudo vi /etc/php-fpm.d/www.conf
```
```
user = apache
group = apache
```
⇣⇣⇣⇣⇣⇣⇣⇣
```
user = nginx
group = nginx
```
3. php-fpm有効にして起動します。
 * `sudo systemctl enable php-fpm`
 * `sudo systemctl start php-fpm`

### MariaDBをインストール
1. yumを使用してインストールする
 * `sudo yum install mariadb mariadb-server`
2. 文字コードの設定   
　[mysqld]の最終行に以下を追記
```
character-set-server=utf8
```
3. systemctlコマンドでmariadbを有効にして起動します。
 * `sudo systemctl enable mariadb.service`
 * `sudo systemctl start mariadb.service`
4. MariaDBの初期設定を対話形式で行います。
 * `mysql_secure_installation`   
　パスワードを聞かれますが、そのままエンターキーを押して続行
 * Set root password?[Y/n]: [enter]
 * New password: [パスワードを入力]
 * Re-enter new password: [パスワードを入力]
 * Remove anonymous users?[Y/n]: [enter]
 * Disallow root login remotely? [Y/n]: [enter]
 * Remove test database and access to it? [Y/n]: [enter]
 * Reload privilege tables now? [Y/n]: [enter]

### MariaDBでユーザ・データベース作成
1. データーベースにログインします。
 * `mysql -u root -p`
 * Enter password: [rootパスワードを入力]
2. データーベースを作成
 * `create database db_wordpress;`
3. ユーザを作成して権限を編集
 * `grant all on データベース名.* to ユーザー名@localhost identified by 'パスワード';`

### 外部から接続するための設定
1. ファイアウォールを無効にします。
 * `sudo systemctl disable firewalld`
 * `sudo systemctl stop firewalld`
2. SELinuxを無効にします。
 * `sudo setenforce 0`
```
vi /etc/selinux/config
```
```
SELinux=enforcing
```
⇣⇣⇣⇣⇣⇣⇣
```
SELinux=disable
```

### Wordpressをインストール
1. wgetでWordpressの最新版をダウンロードします
 * `wget https://ja.wordpress.org/latest-ja.zip`
2. unzipをインストール
 * `sudo yum install unzip`
3. ダウンロードしたWordpressのデータを解凍します
 * `unzip latest-ja.zip`
4. 解凍して出てきたディレクトリを公開ディレクトリに移動する
 * `sudo mv wordpress/ /usr/share/nginx/`
5. ブラウザから`http://192.168.56.130/wp-admin/setup-config.php`にアクセスし、wp-config.phpファイルの設定をしていきます。必要事項を入力したら送信をクリック。
 * データベース名: [MariaDB作成したデータベース名]
 * ユーザー名: [MariaDBで作成したユーザ名]
 * パスワード: [MariaDBで作成したパスワード]
 * データーベースのホスト名: localhost
 * テーブル接頭辞: wp\_   
6. インストールの実行をクリックします。
7. 必要情報を入力していきます
 * サイトのタイトル: [任意のタイトル]
 * ユーザー名: [任意のユーザー名]
 * パスワード: [任意のパスワード]
 * メールアドレス: [任意のメールアドレス]
 * 検索エンジンによるサイトのインデックスを許可する。: チェックを入れる
8. IDとパスワードを入力後ログインをクリックし管理画面を開きます

## 2-3 Wordpressを動かす(3)
Apache HTTP Server 2.2とPHP5.5の環境を構築し、Wordpressを動作させていきます。

※今回はIPアドレスに`192.168.56.131`を使用します   
※vagrantやプロキシの初期設定は既に書いたので省略します。

### MySQLのインストール
今回はデーターベースにMySQLを使用します。

1. MySQLのリポジトリを追加します
 * `sudo yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm`
2. MySQL Community Serverをインストールします
 * `sudo yum -y install mysql-community-server`
3. インストール完了を確認します
 * `mysqld --version`
4. MySQLを有効にして起動します
```
sudo systemctl enable mysqld.service
sudo systemctl start mysqld.service
```

### データーベースとユーザーを作成
1. データベースにログインします
 * `mysqld -u root -p`   
　パスワードを聞かれますが、そのままエンターキーを押して続行
2. データベースを作成します（2-2で既に書いたので説明は省きます。
3. ユーザー権限の設定をします

### Apache HTTP Server 2.2のインストール
1. Apache HTTP Server 2.2をダウンロードします。
 * `wget http://ftp.jaist.ac.jp/pub/apache//httpd/httpd-2.2.29.tar.gz`
2. ダウンロードしたファイルを解凍します。
 * `tar xzf httpd-2.2.29.tar.gz`
3. ディレクトリに移動します
 * `cd httpd-2.2.29`
4. Makefileを作成します
 * `./configure`
5. ビルドします
 * `make`
6. インストールします
 * `make install`
7. 設定ファイルを開き、内容を編集します。
```
sudo vi /usr/local/apache2/conf/httpd.conf
```
```
#ServerName www.example.com:80
DirectoryIndex index.html
```
⇣⇣⇣⇣⇣⇣⇣⇣
```
ServerName localhost:80
DirectoryIndex index.html index.php
```
最終行に以下を追記し、拡張子.phpのファイルをPHPスクリプトとして動作させるための設定します
```
<FilesMatch \.php$>
SetHandler application/x-httpd-php
</FilesMatch>
```

8. バージョンを確認します
 * `/usr/local/apache2/bin/apachectl -v`   
　「Server version: Apache/2.2.29 (Unix)」と表示されたら成功
9. サーバーを起動します。
 * `sudo /usr/local/apache2/bin/apachectl -k start`
10. サーバーを停止します。
 * `sudo /usr/local/apache2/bin/apachectl -k stop`

### libxml2ソースファイルのダウンロード&インストール
PHP5.5インストール時に必要なlibxml2をインストールしていきます。

1. まず、libxml2インストールに必要なPython関連のパッケージをインストールします
 * `sudo yum -y install python-devel`
2. libxml2ソースファイルをダウンロードします。
 * `wget http://xmlsoft.org/sources/libxml2-2.9.2.tar.gz`
3. ダウンロードしたファイルを解凍して移動します
```
tar xzf libxml2-2.9.2.tar.gz
cd  libxml2-2.9.2
```
4. Makefileを作成し、ビルドとインストールをします。
```
./configure
make
sudo make install
```


### PHP5.5のインストール
1. PHPのソースファイルをダウロードします
 * `wget http://jp2.php.net/get/php-5.5.25.tar.gz/from/this/mirror`
2. ダウンロードしたファイルを解凍します
 * `tar xzf mirror`
3. 解凍後ディレクトリを移動します
 * `cd php-5.5.25`
4. コンパイルオプションを指定していきます
```
./configure \
--with-apxs2=/usr/local/apache/bin/apxs \
--with-mysql \
--prefix=/usr/local/apache/php \
--with-config-file-path=/usr/local/apache/php \
--enable-force-cgi-redirect \
--disable-cgi \
--with-zlib \
--with-gettext \
--with-gdbm
```
5. ビルドしてインストールします
```
make
sudo make install
```
6. バージョンを確認
 * `php -v`   
　「PHP 5.5.25 (cli)」と表示されたら成功

### Wordpressのインストール
1. Wordpress最新版をダウンロードします
 * `wget https://ja.wordpress.org/latest-ja.zip`
2. wgetをインストールします。
 * `sudo yum -y install latest-ja.zip`
3. ダウンロードしたファイルを解凍します
 * `unzip latest-ja.zip`
4. 解凍したディレクトリを公開ディレクトリに移動させます
 * `sudo mv wordpress/ /usr/local/apache2/htdocs/`
5. `http://192.168.56.131/wordpress/`にブラウザでアクセスして必要情報を入力していきます
 * データベース名:[MySQLで作成したデータベース名]
 * ユーザー名:[MySQLで作成したユーザ名]
 * パスワード:[MySQLで設定したパスワード]
 * データベースのホスト名:localhost
 * テーブル接頭辞: wp\_   
必要情報を入力したら「送信」ボタンをクリックします。
6. wp-config.php ファイルを手動で作成し、表示されたテキストをコピー&ペーストします
```
sudo vi /usr/local/apache2/htdocs/wordpress/wp-config.php
※`Ctrl+Shit+V`でコピーしたテキストをペーストします
```
ペーストして保存したら「インストール実行」をクリック
7. 必要情報を入力したら「Wordpressをインストール」をクリックして続行(各項目の説明は既に書いたので省略します。
8. ユーザ名とパスワードを入力後「ログイン」をクリック
9. ダッシュボードでサイトタイトルをマウスでホバーして「サイトの表示」を押してサイトが表示されればインストール完了。

## 2-4 ベンチマークを取る

## 2-4 セキュリティチェック
