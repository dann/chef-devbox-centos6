# DESCRIPTION

Chef recipes for devbox.

rbenv, plenv, pyenv, mysql-build, dotfilesをインストールする自分用の開発box作成のためのchefレシピ群。

# INSTALLATION:
## Setup chef and knife-solo

    $ gem install chef
    $ gem install knife-solo
    $ gem install foodcritic
    $ gem install sahara
    $ rbenv rehash

## Setup vagrant
ローカルのホストOSで [VirtualBox](https://www.virtualbox.org/) をインストールします。
その後、vagrantをインストールします。

    $ gem install vagrant
    $ rbenv rehash

vagrantのbox作成します。

    $ mkdir -p ~/vms/centos6
    $ cd ~/vms/centos6
    $ vagrant box add centos6 http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.3-x86_64-v20130101.box
    $ vagrant init

Vagrantfile を適当に記述します。ここでは VM のアドレスを 192.168.50.10 とします。

    Vagrant::Config.run do |config|
      config.vm.box = "centos6"
      config.vm.network :hostonly, '192.168.50.10'
    end

VM を起動します。

    $ vagrant up

vagrant ユーザーで ssh できるよう、~/.ssh/config を編集します。

    Host 192.168.50.2
        IdentityFile ~/.vagrant.d/insecure_private_key    


# Setup server using knife-solo
同ディレクトリ内に本レポジトリを clone した後、knife chef-solo prepare を実行し下準備します。

    # git clone git://github.com/dann/chef-devbox-centos6.git
    $ cd chef-devbox-centos6
    $ knife solo prepare vagrant@192.168.50.10

nodes/192.168.50.10.json を自分の環境に合わせて編集します。
mysql-buildは環境に寄っては時間がかかるので、パッケージで済ませてもいいでしょう。

    {
        "user":{
            "name": "techmemo",
            "group" : "techmemo",
            "home": "/home/techmemo"
        },
        "rbenv":{
            "version": "1.9.3-p362"
        },
        "plenv":{
            "version": "5.16.2"
        },
        "pyenv":{
            "version": "2.7.2"
        },
        "mysql-build":{
            "version": "5.6.10"
        },
        "recipes":[
            "adduser",
            "base_packages",
            "dotfiles",
            "rbenv",
            "pyenv",
            "plenv",
            "mysql-build",
            "chef"
        ]
    } 

knife で chef-solo を実行して、vagrantのサーバーのセットアップ

    $ knife solo cook vagrant@192.168.50.10

以下、動作確認の例。

    $ vagrant ssh
    $ sudo su - techmemo

It works!

# Rake tasks

knifeのコマンドは忘れやすいのでタスクにしてあります。
rakeのタスクを見てください。

    $ rake -T

# SEE ALSO

naoyaさんの[vagrant setup](https://github.com/naoya/vagrant-centos-rbenv_chef)

# TODO
- veeweeでbox作成
- Librarian-chefでcookbookのbundle化 
- cookbook
  - EPEL
  - public key
  - supervisord, nginxなどの追加
