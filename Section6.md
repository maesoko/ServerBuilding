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
 * Domain Name: s13012
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

## 6-6 RDS

## 6-7 ELB

## 6-8 API叩いてみよう
