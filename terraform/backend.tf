# Description: This file contains the configuration for the backend of the terraform state file. This file is used to store the state file in the Proxmox server.
terraform {
    required_providers {
        proxmox = {
            source  = "telmate/proxmox"
            version = "2.9.11"
        }
    }
}


provider "proxmox" {
    pm_api_url          = PM_PROV_URL
    pm_user             = PM_USER
    pm_password         = PM_PASS
    # pm_api_token_id     = PM_API_TOKEN_ID
    # pm_api_token_secret = PM_API_TOKEN_SECRET
    pm_tls_insecure     = true
    pm_debug            = true
    pm_log_enable       = true
    pm_log_file         = PM_LOG_FILE
    pm_log_levels       = {
        _default    = "debug"
        # _capturelog = ""
    }
}
