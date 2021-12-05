
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
    <a href="https://github.com/zhengqbbb/qb"><img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/zhengqbbb/qb?style=social"></a>
    <a href="https://hub.docker.com/repository/docker/qben/qb"><img alt="docker-pull" src="https://img.shields.io/docker/pulls/qben/qb?logo=docker"><img></a>
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

- [Introduction](#introduction)
- [Installation](#installation)
    - [Other installation](#other-installation)
- [How It Works](#how-it-works)
- [Why Do](#why-do)
- [Use](#use)
    - [Use in windows](#use-in-windows)
    - [Use in docker](#use-in-docker)
- [Test](#test)
- [Tip Jar](#tip-jar)

<!-- /TOC -->

## Introduction
🚀 qb is a A fast and simple terminal plugin 🌕 that can **watch your BSC coins price in the terminal**.And manage your local BSC coins list.


<img alt="demogif" src="https://tva1.sinaimg.cn/large/6ccee0e1gy1gwxfgv4jr1g21nm0oo46t.gif" />

## Installation
> base git, curl
```sh
eval "$(curl https://raw.githubusercontent.com/Zhengqbbb/qb/main/install.sh)"
```

### Other installation
> base gitee, curl
```sh
eval "_REMOTE=gitee _G_USER=AAAben" "$(curl https://gitee.com/AAAben/qb/raw/main/install.sh)"
```

## How It Works
- qb is based on [x-cmd](https://github.com/x-cmd) (An open source terminal tool that will subvert the world of posix shell) and **pancakeswap api**.

- It can work on the most [common shells](#test) on the most common operating systems.Such as bash and zsh.

- Use [jq](https://stedolan.github.io/jq/) (json command line tool) to do json parsing.And **x-cmd** will automatically help us dynamically introduce the static build of jq according to the environment. So we don’t have to worry about jq download.

## Why Do

I am Q.ben,A frontend development engineer, and I am also responsible for the maintenance and development of x-cmd. <br/>
At the same time, I also have BSC coins. When I was coding, I wanted to check the the coin's USDT price. I needed to open mobile apps or open the webpage to see it, which was very troublesome. I **just** want to look at coin's USDT price simply.<br/>
So I made qb plugin, which allows me to quickly check the USDT price of my coin in my free time while coding.Quickly open the terminal, and then check the coin's USDT price to continue coding.

- [cointop](https://github.com/cointop-sh/cointop): A shell application for tracking cryptocurrencies.I have used it in the early days, but the page is too complicated. Since I want to see so much information. Then what I should open is the webpage or mobile app, and it seems unable to track Binance Chain information.

## Use
| command | info | 说明 |
|---------|------|------|
| `qb` | **Start** running to watch coins price  | 开始运行查看币价 |
| `qb ls` | **View the list** of locally stored BSC coins  | 查看本地存储的币列表 |
| `qb add` | **Add** BSC address to local list  | 添加BSC地址保存在本地列表之中 |
| `qb del` | **Delete** the BSC address of </br>the selected index to the local list  | 在本地列表删除指定BSC地址 |
| `qb timer` | **Change** the polling **timer**(s)  | 更改轮询币价时间(s) |
| `qb proxy` | **Set up** to use **socket5** for proxy  | 添加/修改socket5的代理地址</br>（**国内必须**） |

### Use in windows
Windows users need to use [Windows terminal](https://github.com/microsoft/terminal) in combination with [WSL](https://docs.microsoft.com/en-us/windows/wsl/install), because this is a terminal based on the posix shell, you should use it like this.

### Use in docker

<p>
<a href="https://hub.docker.com/repository/docker/qben/qb">
<img alt="Docker Base-alpine" src="https://img.shields.io/badge/docker%20base-alpine-blue?logo=docker">
<img alt="docker-pull" src="https://img.shields.io/docker/pulls/qben/qb"><img>
<img alt="Docker Stars" src="https://img.shields.io/docker/stars/qben/qb">
<img alt="Docker Image Size (16.7M)" src="https://img.shields.io/docker/image-size/qben/qb">
</a>
</p>

```sh
# Base Alpine linux/amd64.
docker run -it qben/qb:latest ash
```

---

```sh
# you can also do it. Demo:
docker run -it ubuntu:latest bash
apt update
apt install curl git
eval "$(curl https://raw.githubusercontent.com/Zhengqbbb/qb/main/install.sh)"
```
## Test

| Test | Shell | System |
|-----------|-------|--------|
| ❌    | sh | wait fix |
| ✅    | bash  | MacOS(x86 & ARM) <br/> Ubuntu(x86 & ARM) </br> Debian(x86 & ARM) <br/> Centos(x86 & ARM) |
| ✅     | zsh   | MacOS(x86 & ARM) <br/> Ubuntu(x86 & ARM) |
| ✅     | ash   | Alpine(x86 & ARM) |
| ❌     | dash | MacOS(x86 & ARM) <br/> other wait fix |

## Tip Jar
If you think this project has helped you, and you think this project is good, Could u take me a coffee or give the repo **star**.Thanks~
<br>
<br>
Pass BSC/BEP20
<br>
[![BNB Tip Jar](https://img.shields.io/badge/BNB-tip-blue.svg?logo=binance&style=flat)](https://bscscan.com/address/0xa6635781b7fa8a210978b4a718caf3f01a197cc4) `0xa6635781b7fa8a210978b4a718caf3f01a197cc4` 


