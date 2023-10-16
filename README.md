# repo-backup

本仓库用于所有重要仓库的备份。

## 使用方法

不妨假设需要备份的仓库为`documentation`

1. 生成ssh deploy key，命名规则为仓库名，并存放在服务器`~/repo_key_dir`目录下：e.g. `ssh-keygen -t rsa -C documentation -f ~/repo_key_dir/documentation`
2. 添加deploy key到对应仓库中，i.e. `documentation`
3. 在本仓库中添加`documentation`仓库的submodule：`./add_repo.sh ~/repo_key_dir git@github.com:Peiyang-Aeromodelling-Association/documentation.git`

## 更新脚本

为脚本`update.sh`添加crontab任务

其中，第一个参数和`add_repo.sh`一样，都是指定deploy key的私钥文件夹


