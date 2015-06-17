# Section 6 AWS(Amazon Web Services)

このセクションではAWS(Amazon Web Services)を使用したサーバー構築を行ないます。

## 講義関連リンク

* [AWS公式サイト](http://aws.amazon.com/jp/)
* [Cloud Design Pattern](http://aws.clouddesignpattern.org/index.php/%E3%83%A1%E3%82%A4%E3%83%B3%E3%83%9A%E3%83%BC%E3%82%B8)

## 6-0 AWSコマンドラインインターフェイスのインストール

[公式サイト](http://aws.amazon.com/jp/cli/)参照。

## 6-1	AWS EC2 + Ansible

### AWS-CLIの初期設定
AWSアカウントの取得後、先生からAccess Keyを教えてもらう。
その後、次を実行しAWS-CLIのセットアップをする。
```console
$ aws configure

AWS Access Key ID: [Access Key]
AWS Secret Access Key: [Secret Access Key]
Default region name: ap-northeast-1
Default output format [None]: [Enter]
```

### Amazon EC2 インスタンス用キーペアを作成
1. Amazon EC2 コンソールを開きます
2. 左側の「キーペア」を開きます
3. 「キーペアの作成」をクリックしキーペア名を指定します
4. ダウンロードされる.pemファイルを作業用ディレクトリに移動させます

### Amazon EC2 インスタンスの起動
次のコマンドを実行してインスタンスを起動します
```
aws ec2 run-instances \  
--image-id ami-cbf90ecb \
--key-name 'キーペア名' \
--instance-type t2.micro \
--region "ap-northeast-1" \
--count 1
```

### Amazon EC2 インスタンスにNameタグ付け
インスタンス起動コマンドを叩いた後にインスタンスID(InstanceId)を確認し、Nameタグをつけます
```
aws ec2 create-tags --resources 'インスタンスID' --tags Key=Name,Value='Nameタグ名'
```

### 作成したインスタンスにSSH接続
IPv4のゲートウェイを`172.16.40.10`に変更しておきます。   
インスタンスのPublic IPを確認します
```
$ aws ec2 describe-instances --instance-ids 'インスタンスID' | grep PublicIp
```
キーのパーミッションを変更し、SSH接続をします
```
$ chmod 400 '.pemファイル'
$ ssh -i '.pemファイル' ec2-user@パブリックIPアドレス
```

### playbookを編集
[playbook](Section6/playbook.yml)を参照

### hostsファイルの作成
`vi hosts`を実行し、次を書き込む
```
[all]
インスタンスのパブリックIP
```

### wordpressのインストール
ansible-playbookコマンドを実行します
```
ansible-playbook -i hosts -u ec2 playbook.yml --private-key [.pemファイル]
```
ブラウザでサーバー`http://PublicIp`にアクセスして動作確認をします。

### AMI(Amazon Machine Image)を作る
環境の構築が終わったら、AMIを作成します。AMIを作成後、同じマシンを2つ起動して、コピーができていることを確認します。

EC2コンソールを開き実行したインスタンスを右クリックしイメージ ＞ イメージの作成をクリックし、必要項目を入力します。

 * イメージ名: [任意のイメージ名]
 * イメージの説明: [任意のイメージの説明] 

イメージの作成をクリックします。   
作成したAMIを使って、同じマシンを起動するため、次のコマンドを実行
```
aws ec2 run-instances \  
--image-id '作成したAMIのイメージID' \
--key-name 'キーペア名' \
--instance-type t2.micro \
--region "ap-northeast-1" \
--count 1
``` 

ブラウザでサーバー`http://PublicIp`にアクセスして、wordpressで作成したページが表示されれば完了

## 6-2 AWS EC2(AMIMOTO)
AMIMOTOのWordpressを起動してWordpressが見れることを確認します。

EC2のインスタンスを作成します
 * AMI(AWS Marketplace): WordPress powered by AMIMOTO (HHVM)
 * インスタンスタイプ: t2.micro
 * インスタンスのタグ付け: 任意のタグ名

作成後次のアドレスにアクセスしWordPressが見れることを確認します。
```
http://インスタンスのパブリックIP
```

## 6-3 Route53
Section5で作ったDNSの情報をRoute53に突っ込みます。

### Route53 ゾーンファイル作成
AWSコンソール > サービス > Route53 > Hosted Zones > Create Hosted Zoneをクリックします。   
 * Domain Name: s13012.com
 * Comment: 任意のコメント
 * Type: Public Hosted Zone

「Import Zone File」をクリックし、テキストボックスに[ゾーンファイル](Section5/ansible/zone.s13012.com)の情報を書き込みます。   
インポートした後にページを更新し、変更が反映されていれば完了。


## 6-4 S3
Webサイトを作り、S3にアップロードし、公開します。

### バケットの作成
AWSコンソール ＞ サービス ＞ S3 ＞ パケットを作成をクリックし、バケットを作成します。
 * バケット名:[任意のバケット名]

### ファイルのアップロード 
次のコマンドを実行しファイルをアップロードします。 
```
aws s3 cp ファイル名 s3://バケット名/ 
``` 
作成したバケットのページを更新して、ファイルがアップロードされているのを確認できれば完了 

## 6-5 CloudFront 
6-1で作ったAMIを起動し、CloudFrontに登録します。登録して直接アクセスするのとCloudFront経由するのどっちが速いかベンチマークを取ります。

### AMIの起動
6-1で作成したAMIを選択し、EC2のインスタンスを起動します。
```
aws ec2 run-instances \  
--image-id [6-1で作成したAMIのID] \
--key-name 'キーペア名' \
--instance-type t2.micro \
--region "ap-northeast-1" \
--count 1
```

### CloudFrontを立ち上げる

AWSコンソール > サービス > CloudFront > Create Distributionの順に進みます

1. Select delivery method: Webを選択
2. Create distribution
 * Origin Domain Name: EC2インスタンスのパプリックDNS
 * その他詳細設定はデフォルトのまま
3. ディストリビューション一覧画面で、作成したディストリビューションのStatusが「Deployed」になるまで待機
4. CloudFrontのドメインからWordPressが表示されれば完了

### Wordpressが重い場合の対処法
インスタンスにSSH接続し、次を実行します。
```
$ mysql -u s13012 -p
Enter password: [mysqlのパスワード]

mysql> UPDATE wp_options SET option_value = "/" where option_id in (1,2);
```

### ベンチマーク
直接アクセスするのとCloudFront経由するのどっちが速いかabコマンドでベンチマークを取ってみましょう。

```
ab -X 172.16.40.1:8888 [サイトのURL]
```

### ベンチ結果

```console
#EC2

Server Software:        nginx/1.6.2
Server Hostname:        ec2-52-68-221-6.ap-northeast-1.compute.amazonaws.com
Server Port:            80

Document Path:          /
Document Length:        8486 bytes

Concurrency Level:      1
Time taken for tests:   0.223 seconds
Complete requests:      1
Failed requests:        0
Total transferred:      8831 bytes
HTML transferred:       8486 bytes
Requests per second:    4.48 [#/sec] (mean)
Time per request:       223.238 [ms] (mean)
Time per request:       223.238 [ms] (mean, across all concurrent requests)
Transfer rate:          38.63 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
              Connect:        1    1   0.0      1       1
              Processing:   222  222   0.0    222     222
              Waiting:      213  213   0.0    213     213
              Total:        223  223   0.0    223     223

```

```
#CloudFront

Server Software:        nginx/1.6.2
Server Hostname:        d1de8lpaw19c0y.cloudfront.net
Server Port:            80

Document Path:          /
Document Length:        8486 bytes

Concurrency Level:      1
Time taken for tests:   0.132 seconds
Complete requests:      1
Failed requests:        0
Total transferred:      9009 bytes
HTML transferred:       8486 bytes
Requests per second:    7.56 [#/sec] (mean)
Time per request:       132.316 [ms] (mean)
Time per request:       132.316 [ms] (mean, across all concurrent requests)
Transfer rate:          66.49 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
              Connect:        1    1   0.0      1       1
              Processing:   131  131   0.0    131     131
              Waiting:      119  119   0.0    119     119
              Total:        132  132   0.0    132     132

```

## 6-6 RDS
RDSを立ち上げて、6-1で作ったAMIのWordpressのDBをRDSに向けてみよう。



## 6-7 ELB

## 6-8 API叩いてみよう
