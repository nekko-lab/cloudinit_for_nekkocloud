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

- 
