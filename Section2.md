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
2. Nginxをyumでインストール
 * `sudo yum install nginx`
3. Nginxを有効にして起動します
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


## 2-4 ベンチマークを取る

