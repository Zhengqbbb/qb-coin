<p align="center">
    <a href="#">
        <img src="https://user-images.githubusercontent.com/40693636/144716462-5f4dc978-a6af-4b54-8f27-79af05ceccf6.png" alt="image" width="200" data-width="200" data-height="200">
    </a>
</p>

<h1 align="center">QB</h1>
<p align="center">
    <a href="https://bscscan.com/address/0xa6635781b7fa8a210978b4a718caf3f01a197cc4"><img alt="BNB" src="https://img.shields.io/badge/Binance-tool-yellow.svg?logo=binance&style=flat"><img>
    <br/>
    <a href="https://github.com/zhengqbbb/qb/blob/main/LICENSE"><img alt="license" src="https://img.shields.io/badge/license-MIT-blue.svg"><img>
    </a>
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/zhengqbbb/qb?style=social">
    <br/>
    <a href="https://github.com/zhengqbbb/qb">
    <img alt="GitHub top language" src="https://img.shields.io/github/languages/top/zhengqbbb/qb?logoColor=orange&style=flat-square">
    <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/zhengqbbb/qb"><img>
    </a>
</p>
<p align="center">
    <a href="https://github.com/Zhengqbbb/qb/blob/main/README.md">English doc</a>
    &nbsp; | &nbsp;
    <a href="https://github.com/Zhengqbbb/qb/blob/main/README.zh-CN.md">简体中文文档</a>
</p>


<!-- TOC -->

- [介绍](#介绍)
- [下载](#下载)
    - [Gitee源下载](#gitee源下载)
- [组成](#组成)
- [痛点](#痛点)
- [使用](#使用)
    - [在windows中使用](#在windows中使用)
    - [在docker之中使用](#在docker之中使用)
- [测试](#测试)
- [打赏](#打赏)

<!-- /TOC -->

## 介绍
🚀 qb 是一款简洁快速的终端插件, 🌕 他可以让你在终端中查看币安生态链上的币价，也可以帮助你管理你的本地的币安链信息，并且国内用户可以方便管理和开启终端代理.


<img alt="demogif" src="https://tva1.sinaimg.cn/large/6ccee0e1gy1gwxfgv4jr1g21nm0oo46t.gif" />

## 下载
> 需要 git, curl。**国内推荐使用gitee源下载**，我会同时维护~
```sh
eval "$(curl https://raw.githubusercontent.com/Zhengqbbb/qb/main/install.sh)"
```

### Gitee源下载
> 需要 gitee, curl
```sh
eval "_REMOTE=gitee _G_USER=AAAben" "$(curl https://gitee.com/AAAben/qb/raw/main/install.sh)"
```

## 组成
- qb 是基于 [x-cmd](https://github.com/x-cmd) (一款即将颠覆posix shell世界的开源终端工具) 和 并使用了 **薄饼的API**.

- qb可以在常见的posix shell环境使用，比如bash和zsh。

- 使用了[jq](https://stedolan.github.io/jq/) (shell json的处理工具)去完成json的解析，同时x-cmd会动态判断你的环境下载静态编译文件，所以我们无需担心jq下载问题。

## 痛点
我是一名前端开发，目前正在致力于开发和维护开源项目x-cmd。<br>
同时我也是一个币安链的持有人。当我日常写代码的时候，我想要去看看追踪币价格时，我需要打开手机的App或者去网页，这让我感觉非常麻烦，我仅仅只是想简单方便地看一下当前价格而已。
<br>
于是我开发了qb插件，他让我可以简单，快速去查看币安链上币的USDT的价格，然后再继续coding。

- [cointop](https://github.com/cointop-sh/cointop): 一款shell的加密货币查看工具。我在早期的时候有使用过...我感觉太复杂并且太多信息了，拜托如果我要这么多信息我应该打开的是手机的app或者网页了，而且很难操作，似乎追踪不了币安生态链的币。

## 使用
| 命令 | 说明 |
|---------|------|
| `qb` | 开始运行查看币价 |
| `qb ls` | 查看本地存储的币安链的列表 |
| `qb add` | 添加BSC地址保存在本地列表之中 |
| `qb del` | 在本地列表删除指定索引BSC地址 |
| `qb timer` | 更改轮询币价时间(单位：秒) |
| `qb proxy` | 添加/修改socket5的代理地址</br>（**国内必须**，当然也可以使用本地局域网中其他人的地址</br>比如同事的，输入他的ip加他socket5的端口） |

### 在windows中使用
Windows需要使用[Windows terminal](https://github.com/microsoft/terminal) 配合 [WSL](https://docs.microsoft.com/en-us/windows/wsl/install), 因为这才是近似基于posix shell的终端，你日常也应该这样使用。

### 在docker之中使用
```sh
# 基于 Alpine linux/amd64. 镜像大小: 22.8MB
docker pull qben/qb:latest && docker run -it qben/qb:latest ash
```

```sh
# 当然你想要在一个隔离环境中使用，也可以
docker run -it ubuntu:latest bash
apt update
apt install curl git
eval "_REMOTE=gitee _G_USER=AAAben" "$(curl https://gitee.com/AAAben/qb/raw/main/install.sh)"
```

## 测试

| 测试是否通过 | Shell类似 | 系统 |
|------------|-------|--------|
| ❌          | sh | 等待修复 |
| ✅          | bash  | MacOS(x86 & ARM) <br/> Ubuntu(x86 & ARM) </br> Debian(x86 & ARM) <br/> Centos(x86 & ARM) |
| ✅           | zsh   | MacOS(x86 & ARM) <br/> Ubuntu(x86 & ARM) |
| ✅           | ash   | Alpine(x86 & ARM) |
| ❌           | dash |  等待修复 |


## 打赏
如果你觉得这个项目对你有帮助，而且你觉得这个项目不错，不妨请我喝杯咖啡或者给一个**star**
<br>
<br>
通过 BSC/BEP20
<br>
[![BNB Tip Jar](https://img.shields.io/badge/BNB-tip-blue.svg?logo=binance&style=flat)](https://bscscan.com/address/0xa6635781b7fa8a210978b4a718caf3f01a197cc4) `0xa6635781b7fa8a210978b4a718caf3f01a197cc4` 


