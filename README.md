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
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img -O ubuntu-22.04-server-cloudimg-amd64.img
```

- テンプレート用のVMを作成

```bash
qm create <VM ID> --memory 2048 --net0 virtio,bridge=vmbr0
```

- localのstorageにISOファイルをインポート

```bash
qm importdisk <VM ID> ubuntu-22.04-server-cloudimg-amd64.img local-lvm
```

- VMをセットアップ

```bash
qm set <VM ID> --scsi0 local-lvm:0,import-from=/root/ubuntu-22.04-server-cloudimg-amd64.img
qm set <VM ID> --name <VM Name>
qm set <VM ID> --scsihw virtio-scsi-pci --virtio0 local-lvm:vm-<VM ID>-disk-0
qm set <VM ID> --boot order=virtio0
qm set <VM ID> --ide2 local-lvm:cloudinit
qm set <VM ID> --nameserver 192.168.0.1
# qm set <VM ID> --nameserver 192.168.0.1 --searchdomain example.com
```

- VMテンプレートにコンバートする

```bash
qm template <VM ID>
```

---

## Netbird覚え書き

### Netbirdのインストール

### Netbirdの接続方法

- `netbird service install`を実行してnetbirdをインストール
- `netbird service start`を実行してNetbird deamonを起動
- `netbird login`を実行して登録したVPNにログイン
- `netbird up`を実行してnetbirdのネットワークに参加
- `netbird status`を実行してステータスが`Connected`になっていればOK

---

## Terraformを使ってProxmoxのcloud-initから自動デプロイ

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

- `pvesh create /access/users/terraform-prov@pve/token/NekkoCloud --privsep 0`を実行してトークンを発行

```bash
$ pvesh create /access/users/terraform-prov@pve/token/NekkoCloud --privsep 0
┌──────────────┬──────────────────────────────────────┐
│ key          │ value                                │
╞══════════════╪══════════════════════════════════════╡
│ full-tokenid │ terraform-prov@pve!NekkoCloud        │
├──────────────┼──────────────────────────────────────┤
│ info         │ {"privsep":"0"}                      │
├──────────────┼──────────────────────────────────────┤
│ value        │ xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx │
└──────────────┴──────────────────────────────────────┘
```

### TerraformでVMをデプロイ

このリポジトリをクローンしていることが前提です。ま、さすがにもうやってくれてるよね？

- `cd .\terraform`でtfファイルが保存されたディレクトリへ移動
- `terraform init`を実行して初期化

```bash
$ terraform init

Initializing the backend...
Initializing modules...

Initializing provider plugins...
- Reusing previous version of telmate/proxmox from the dependency lock file
- Using previously-installed telmate/proxmox v3.0.1-rc1

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

<details>
<summary>各種VMの設定項目を記述する</summary>

  - `backend.tf`の`local`にあるVMリソースの項目を適宜設定する
    - `vm_name-0`: Cloud-Initで事前に作成したVMテンプレートの名前
    - `vmid-0`: Proxmox VMID
    - `clone-0`: Proxmoxクラスター上にデプロイされるVMの数
    - `cores-0`: VMのコア数（デフォルトは1）
    - `memory-0`: VMのメモリ数（デフォルトは2048MB）
    - `disk_size-0`: VMのストレージ（デフォルトは2252MB）
  - その他秘匿性の高い情報は`terraform.tfvars`を各自作成し、`terraform.tfvars.template`を参考に内容を記述すること

</details>

- `terraform plan`を実行してtfファイルに問題が無いか確認を行ってもらう
- `terraform apply`を実行してデプロイ
  `yes`と入力して開始！

```bash
$ terraform apply
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 

~~~

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

- VMを削除する場合は`terraform destroy`を実行する
  `yes`と入力して開始！

```bash
$ terraform destroy

~~~

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value:

~~~

Destroy complete! Resources: 2 destroyed.
```

***VMにログインできません！！！***

---

## 尾張に

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
