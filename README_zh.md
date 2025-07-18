我个人使用的Nix flake配置。
# 安装
## MacOS
### 1. 安装 Nix
推荐的安装方法是使用 [determinate](https://determinate.systems/)。
> 重要提示：安装程序会询问你是否要安装 Determinate Nix。请选择否，因为它目前与nix-darwin存在冲突。
### 2. 克隆此仓库
```bash
git clone https://github.com/smashell/nix-config && cd nix-config
```
### 3. 配置当前用户信息
```bash
nix run .#apply
```
### 4. 自定义Nix配置
#### 4.1 定制要安装的软件包
查看以下文件，根据需要进行修改：
- modules/darwin/casks.nix
- modules/darwin/packages.nix
- modules/shared/packages.nix
#### 4.2 定制你的shell配置
可以将你现有的~/.zshrc中的内容添加进来，或直接使用这个新的配置。
- modules/darwin/home-manager
- modules/shared/home-manager
### 5. 可选：设置密钥(secrets)
这里只是设置了必要的配置，具体使用secrets加密、解密敏感文件，参看[如何加解密文件](#如何加解密文件)一节。
#### 5.1 创建私有Github仓库保存你的密钥
在Github上创建一个你自己的私有nix-secrets仓库，并至少添加一个文件（例如README.md）。在安装过程中需要输入此仓库名称。
#### 5.2 设置密钥
创建新密钥：
```bash
nix run .#create-keys
```
执行上面的命令，会在`~/.ssh`下创建名为`id_ed25519`和`id_ed25519_agenix`的私钥和公钥。
### 6. 构建和部署
选择以下两个方式之一。
#### 6.1 方法1:先构建然后部署
在部署配置之前确保构建正常运行，请执行：
```bash
nix run .#build
```
最后，使用以下命令部署配置，使之生效：
```bash
nix run .#switch
```
### 6.2 方法2:一键构建及部署
相当于合并了上面两步为一步：
```bash
nix run .#build-switch
```
# 如何加解密文件
下面以加密`ClashX`的配置`~/.config/clash/CuteCloud.yaml`为例。
## 1. 加密文件
### 1.1 clone上面创建的nix-secrets仓库
```bash
git clone git@github.com:smashell/nix-secrets.git && cd nix-secrets
```
### 1.2 创建`secrets.nix`文件
```nix
let
  # public key created by nix run .#create-keys: ~/.ssh/id_ed25519_agenix.pub
  smashell = "ssh-ed25519 AAAAC..."；
  users = [ smashell ];
  systems = [ ];
in
{
  "cute-cloud-conf.age".publicKeys = [ smashell ];
}
```
### 1.3 加密文件
执行下面的代码，会打开vim，然后把`CuteCloud.yaml`文件内容复制粘贴进来。然后，保存推出vim，则会生成`cute-cloud-conf.age`加密文件。
```bash
EDITOR=vim nix run github:ryantm/agenix -- -e cute-cloud-conf.age
```
### 1.4 提交文件
提交`secrets.nix`和`cute-cloud-conf.age`文件到远程仓库`nix-secrets`.
## 2. 解密文件
### 2.1 更新`flake.lock`
加密的操作都是在`nix-secrets`目录下操作的，现在回到nix-config目录下执行`nix flake update`更新lock文件。
### 2.2 配置解密文件
编辑`modules/darwin/secrets.nix`文件：
```nix
{ config, pkgs, agenix, secrets, ... }:

let user = "smashell"; in
{
  age.identityPaths = [
    "/Users/${user}/.ssh/id_ed25519_agenix"
  ];

  age.secrets."cute-cloud-conf" = {
    symlink = true;
    path = "/Users/${user}/clash/CuteCloud.yaml";
    file =  "${secrets}/cute-cloud-conf.age";
    mode = "600";
    owner = "${user}";
  };
}
```
### 2.3 解密文件
```bash
nix run .#build-switch
```
# 感谢
 - [dustinlyons](https://github.com/dustinlyons/nixos-config/)：这是个非常好的nix flake框架，本配置就是在此基础上修改的。
 - [ryan4yin](https://github.com/ryan4yin/nix-config)：同样很棒的项目，从这个项目中学到了很多。
