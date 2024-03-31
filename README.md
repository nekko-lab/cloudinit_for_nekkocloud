# Terraform × Cloud-InitでVMセットアップをいい感じにする

---

## はじめに

### TL;DR

- cloud initはLinuxの初期設定を簡単にするもの
- Proxmox VEをTerraformで楽々珍々にする方法をメモしたもの
- Terraform大好き😍

### [cloud init][cloud-initを使ったLinux OSの初期設定]とは

上記の通りLinux OSのインスタンスの初期設定をいい感じに自動化してくれる優れもの。GUIとCLIどちらでも設定可能。今回はTeraformのProxmox Providerを使って外部からUbuntuインスタンスの作成を目標とする。

### [Terraform][Terraformとは | IBM]とは

> Terraform は、クラウドおよびオンプレミスのリソースを安全かつ効率的に構築、変更、バージョン管理できるコード ツールとしてのインフラストラクチャです。

Application Programming Interfaces (APIs)が使えるほとんどのプラットフォームでTerraformは使用可能だとか。すげー🙌

### Proxmox VEのVM作成を自動化するメリット

- 冪等性の確保
- スケーラブルな変更
- 作業効率の向上

---

## Cloud-Initの使い方

作成したIMGファイルからテンプレートを作成して、クローンすることでVMのセットアップの手間を省くことができる。
Cloud-Initはそれを可能にし、クラウドでのIaCを行う上では欠かせないツールである。
ProxmoxでCloud-Initを使用し、各種VMのデプロイを自動化する。

- Proxmoxのノードに入り、VMに使用するイメージをダウンロードする
  今回使用したイメージは[Ubuntu server Cloudimg 22.04LTS](https://cloud-images.ubuntu.com/)
  
```bash
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
```

- テンプレート用のVMを作成

```bash
qm create 9000 --memory 2048 --net0 virtio,bridge=vmbr0
```

- ダウンロードしたイメージをlocal-lvmにセット
  
```bash
qm set 9000 --scsi0 local-lvm:0,import-from=/root/jammy-server-cloudimg-amd64.img
```

---

## Proxmox と Terraformの場合

### Proxmoxクラスタの設定

- Terraform用の新しいロール`TerraformProvider`を作成

```bash
pveum role add TerraformProvider -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
```

- 新しいユーザ`terraform-prov@pve`を作成

```bash
pveum user add terraform-prov@pve --password <password>
```

- ロール`TerraformProvider`をユーザ`terraform-prov@pve`に追加

```bash
pveum aclmod / -user terraform-prov@pve -role TerraformProvider
```

---

## 参考文献

1. [cloud-initを使ったLinux OSの初期設定]
2. [Terraformとは | IBM]
3. [Proxmox Provider]
4. [Proxmox上のLXCをTerraformで管理する]

[cloud-initを使ったLinux OSの初期設定]: https://qiita.com/yamada-hakase/items/40fa2cbb5ed669aaa85b
[Terraformとは | IBM]: https://www.ibm.com/jp-ja/topics/terraform
[Proxmox Provider]: https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
[Proxmox上のLXCをTerraformで管理する]: https://zenn.dev/bootjp/articles/692e8058e346b6
