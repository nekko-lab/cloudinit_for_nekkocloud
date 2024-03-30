# Terraform × Cloud-InitでVMセットアップをいい感じにする

---

## はじめに

### TL;DR

あいうえお

---

## Proxmoxクラスタの設定

- Terraform用の新しいロール`TerraformProvider`を作成

```bash
pveum role add TerraformProvider -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
```

- 新しいユーザ`terraform-prov@pve`を作成 @irumaru

```bash
pveum user add terraform-prov@pve --password <password>
```

- ロール`TerraformProvider`をユーザ`terraform-prov@pve`に追加

```bash
pveum aclmod / -user terraform-prov@pve -role TerraformProvider
```

- 
