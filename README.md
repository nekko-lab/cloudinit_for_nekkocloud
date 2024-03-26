# Cloud-Init

---

## これはなに

作成したIMGファイルからテンプレートを作成して、クローンすることでVMのセットアップの手間を省くことができる。
Cloud-Initはそれを可能にし、クラウドでのIaCを行う上では欠かせないツールである。

## なにができるの

ProxmoxでCloud-Initを使用し、各種VMのデプロイを自動化する。

## どうやるの

- Proxmoxのノードに入り、VMに使用するイメージをダウンロードする
  今回使用したイメージはUbuntu server Clouding 22.04LTS
  https://cloud-images.ubuntu.com/
  
  ```
  wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
  ```

- テンプレート用のVMを作成
  
  ```
  qm create 9000 --memory 2048 --net0 virtio,bridge=vmbr0
  ```

- ダウンロードしたイメージをlocal-lvmにセット
  
  ```
  qm set 9000 --scsi0 local-lvm:0,import-from=/root/jammy-server-cloudimg-amd64.img
  ```

# Terraform & Cloud-Initを使用したProxmoxの使い方

---

## はじめに

### TL;DR

- cloud initはLinuxの初期設定を簡単にするもの
- Proxmox VEをIaCで楽々珍々にする方法をメモしたもの
- Terraform大好き😍

### [cloud init][cloud-initを使ったLinux OSの初期設定]とは

上記の通りLinux OSのインスタンスの初期設定をいい感じに自動化してくれる優れもの。GUIとCLIどちらでも設定可能。今回はTeraformのProxmox Providerを使って外部からUbuntuインスタンスの作成を目標とする。

### Terraformとは

> Terraform は、クラウドおよびオンプレミスのリソースを安全かつ効率的に構築、変更、バージョン管理できるコード ツールとしてのインフラストラクチャです。

Application Programming Interfaces (APIs)が使えるほとんどのプラットフォームでTerraformは使用可能だとか。すげー🙌

### Proxmox VEのVM作成を自動化するメリット

- 冪等性の確保
- スケーラブルな変更
- 作業効率の向上

---

## Proxmox VE & cloud initのセットアップ

### cloud initのインストール

---

## 参考文献

1. [cloud-initを使ったLinux OSの初期設定]
2. [Proxmox Provider]

[cloud-initを使ったLinux OSの初期設定]: https://qiita.com/yamada-hakase/items/40fa2cbb5ed669aaa85b
[Proxmox Provider]: https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
