global_settings = {
  default_region = "region1"
  regions = {
    region1 = "eastus"
  }
}

resource_groups = {
  rg1 = {
    name   = "example-agw"
    region = "region1"
  }
}
storage_accounts = {
  sa1 = {
    name                     = "sa1"
    resource_group_key       = "rg1"
    account_kind             = "BlobStorage"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}
storage_data_lake_gen2_filesystem = {
  sdlg21 = {
    name = "example"
    storage_account = {
      key = "sa1"
    }
  }
}

synapse_workspace = {
  syws1 = {
    name = "example"
    resource_group = {
      key = "rg1"
    }
    location = "region1"
    storage_data_lake_gen2_filesystem = {
      key = "sdlg21"
    }
    sql_administrator_login          = "sqladminuser"
    sql_administrator_login_password = "H@Sh1CoR3!"
    tags = {
      Env = "production"
    }
  }
}
synapse_sql_pool = {
  sysp1 = {
    name = "examplesqlpool"
    synapse_workspace = {
      key = "syws1"
    }
    sku_name    = "DW100c"
    create_mode = "Default"
  }
}

synapse_sql_pool_security_alert_policy = {
  syspsap1 = {
    policy_state = "Enabled"
    sql_pool = {
      key = "sysp1"
    }
    storage = {
      key = "sa1"
      #endpoint                               = azurerm_storage_account.audit_logs.primary_blob_endpoint
      #access_key                             = azurerm_storage_account.audit_logs.primary_access_key
      storage_account_access_key_is_secondary = false
    }
    disabled_alerts = [
      "Sql_Injection",
      "Data_Exfiltration"
    ]
    retention_days = 20
  }
}