# repo-backup

本仓库用于重要仓库的自动备份。目前在服务器上使用定时脚本运行。每周一早上10点会将本仓库以及其submodule链接的子仓库的默认分支更新到最新版本、提交并打包压缩。

压缩包将存储在特定文件夹中（由`update_backup_repo.sh`脚本的第三个参数指定），最多历史版本（压缩包数目）由第四个参数指定。

## 添加新的需要备份的仓库

不妨假设需要备份的仓库为`documentation`

1. 生成ssh deploy key，**命名规则为仓库名**，并存放在服务器`~/repo_key_dir`目录下：e.g. `ssh-keygen -t rsa -C documentation -f ~/repo_key_dir/documentation`
2. 添加deploy key到对应仓库中，i.e. `documentation`
3. 在本仓库目录下添加`documentation`仓库的submodule：`./add_repo.sh ~/repo_key_dir git@github.com:Peiyang-Aeromodelling-Association/documentation.git`

## 关于定时脚本配置

为脚本`update_backup_repo.sh`添加crontab任务

其中，第一个参数和`add_repo.sh`一样，都是指定deploy key的私钥文件夹

更新脚本将会定期拉取所有仓库的最新版，并保存一个压缩包到第三个参数指定的目录，压缩包最大数量由第四个参数指定，将会轮转式删除最老版本。

## 脚本参数说明

`add_repo.sh`:

1. 存放所有仓库的ssh密钥（deploy key）的目录
2. 远程仓库地址

`update_backup_repo.sh`:

1. 存放所有仓库的ssh密钥（deploy key）的目录
2. 本地仓库地址
3. 备份压缩包存放目录
4. 最大备份数量
