# Section 5 DNSサーバーを動作させる

## 5-1 bindのインストール

[README](Section5/README.md)を参考に、事前準備を済ませたらVagrantfileがある場所で`vagrant up`を実行

## 5-2 bindの設定

### named.confの編集
 [master-named.conf](Section5/ansible/master-named.conf)と[slave-named.conf](Section5/ansible/slave-named.conf)を参照して、master-named.confとslave-named.confを編集します。

### ゾーンファイルの作成
 [ゾーンファイル](Section5/ansible/zone.s13012.com)を参照してゾーンファイルを作成し、レコードを返すように設定します。

### playbookの編集
[playbook](Section5/ansible/playbook.yaml)を参照してplaybook.yamlを編集します。

### 設定の反映
変更した設定を反映させるために次のコマンドを実行します
```
vagrant reload
vagrant provision
```

### 動作確認
digコマンドを使用して動作確認をします
```
#マスターサーバー
$ dig @マスターサーバーのIPアドレス ns s13012.com
```

```
#スレーブサーバー
$ dig @スレーブサーバーのIPアドレス ns s13012.com
```
