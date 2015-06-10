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

### Amazon EC2 インスタンスを作成
1. AWSのページからEC2のダッシュボードに移動する
2. インスタンスの作成をクリックする
3. AMIに"Amazon Linux AMI"を選択する
4. インスタンスに"t2.micro"を選択し「確認と作成」をクリック
5. インスタンス作成の確認画面で「作成」をクリックする
6. 「新しいキーペアの作成」をコンボボックスから選び、キーペア名を指定後、キーペアのダウンロードをクリックし.pemファイルをダウンロード

### AMI(Amazon Machine Image)を作る

## 6-2 AWS EC2(AMIMOTO)
## 6-3 Route53

## 6-4 S3

## 6-5 CloudFront

## 6-6 RDS

## 6-7 ELB

## 6-8 API叩いてみよう
