# Section 3 Ansibleによる自動化とテスト

## 3-0 Ansibleのインストール

以下のコマンドを実行
```
$ sudo apt-get install software-properties-common
$ sudo apt-add-repository ppa:ansible/ansible
$ sudo apt-get update
$ sudo apt-get install ansible
```

### vagrant初期設定
Vagrantfileを開き以下を追記
```
config.vm.box = "CentOS7"
config.vm.network "private_network", ip:"192.168.56.133"
```

###プロキシの設定
Vagrantfileを開き以下を追記

```
if Vagrant.has_plugin?("vagrant-proxyconf")
config.proxy.http = ENV['http_proxy']
config.proxy.https = ENV['https_proxy']
config.proxy.no_proxy = ENV['no_proxy'] 
end

```
以下のコマンドを実行
```
vagrant plugin install vagrant-proxyconf
vagrant plugin install vagrant-vbguest
```

## 3-1 ansibleでWordpressを動かす(2)を行なう

### 3-1-2? VagrantfileからAnsibleを呼び出す
Vagrantfileに以下を追記
```
config.vm.provision "ansible" do |ansible|
ansible.playbook = "playbook.yml"
end
```
### playbookを作成
[playbook.yml](playbook.yml)を内容をコピー

