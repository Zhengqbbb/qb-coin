# Qb
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/zhengqbbb/qb/blob/main/LICENSE)
<!-- TOC -->

- [Qb](#qb)
    - [Install](#install)
    - [What](#what)
    - [Base](#base)
    - [Why](#why)
    - [Use](#use)
    - [Test](#test)

<!-- /TOC -->

## Install
```shell
eval "$(curl https://raw.githubusercontent.com/Zhengqbbb/qb/main/install.sh)"
```

## What
🚀 qb is a terminal plugin that can 🌕 **watch your BSC coins price in the terminal**.

<img alt="demogif" src="https://tva1.sinaimg.cn/large/6ccee0e1gy1gwxfgv4jr1g21nm0oo46t.gif">

## Base
- It is based on x-cmd (a powerful shell tool) and pancakeswap api.

- It can work in zsh and common posix shells such as bash.

## Why


## Use
| command | info | 说明 |
|---------|------|------|
| `qb` | **Start** running to watch coins price  | 开始运行查看币价 |
| `qb ls` | **View the list** of locally stored BSC coins  | 查看本地存储的币列表 |
| `qb add` | **Add** BSC address to local list  | 添加BSC地址保存在本地列表之中 |
| `qb del` | **Delete** the BSC address of </br>the selected index to the local list  | 在本地列表删除指定BSC地址 |
| `qb timer` | **Change** the polling **timer**(s)  | 更改轮询币价时间(s) |
| `qb proxy` | **Set up** to use **socket5** for proxy  | 添加/修改socket5的代理地址</br>（**国内必须**） |

## Test

- [x] x86 zsh
- [x] x86 bash
