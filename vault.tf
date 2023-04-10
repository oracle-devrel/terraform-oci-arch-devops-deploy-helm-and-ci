## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_kms_vault" "vault" {
  #Required
  count          = var.create_new_vault ? 1 : 0
  compartment_id = var.compartment_ocid
  display_name = "${var.app_name}_vault"
  vault_type = var.vault_vault_type

  #Optional
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}

resource "oci_kms_key" "vault_master_key" {
  #Required
  compartment_id = var.compartment_ocid
  display_name = "${var.app_name}_vault_masterkey"
  count          = var.create_new_vault ? 1 : 0
  key_shape {
    #Required
    algorithm = var.vault_key_shape_algorithm
    length = var.key_key_shape_length
  }
  management_endpoint = oci_kms_vault.vault[0].management_endpoint
  #management_endpoint = oci_kms_vault.vault[0].management_endpoint

  #Optional
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  protection_mode = "${var.vault_key_protection_mode}"
}

resource oci_vault_secret "aws_access_key_id" {
  compartment_id = var.compartment_ocid
  key_id = local.vault_key_ocid #oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.aws_access_key_id)
  }
  secret_name    = "aws_access_key_id"
  vault_id       = local.vault_ocid #oci_kms_vault.vault.id
}

resource oci_vault_secret "aws_access_key" {
  compartment_id = var.compartment_ocid
  key_id = local.vault_key_ocid #oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.aws_access_key)
  }
  secret_name    = "aws_access_key"
  vault_id       = local.vault_ocid #oci_kms_vault.vault.id
}

resource oci_vault_secret "helm_repo_user" {
  compartment_id = var.compartment_ocid
  key_id = local.vault_key_ocid #oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.oci_user_name)
  }
  secret_name    = "helm_repo_user"
  vault_id       = local.vault_ocid #oci_kms_vault.vault.id
}

resource oci_vault_secret "helm_repo_token" {
  compartment_id = var.compartment_ocid
  key_id = local.vault_key_ocid #oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.oci_user_authtoken)
  }
  secret_name    = "helm_repo_token"
  vault_id       = local.vault_ocid #oci_kms_vault.vault.id
}

resource oci_vault_secret "gpg_passphrase" {
  compartment_id = var.compartment_ocid
  key_id = local.vault_key_ocid #oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.gpg_passphrase)
  }
  secret_name    = "gpg_passphrase_new"
  vault_id       = local.vault_ocid #oci_kms_vault.vault.id
}

resource oci_vault_secret "gpg_pub_key" {
  compartment_id = var.compartment_ocid
  key_id = local.vault_key_ocid #oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = "dummy"
  }
  secret_name    = "gpg_pub_key"
  vault_id       = local.vault_ocid #oci_kms_vault.vault.id
}

locals {
  vault_ocid = var.create_new_vault ? oci_kms_vault.vault[0].id : var.existing_vault_ocid
  vault_key_ocid = var.create_new_oke_cluster ? oci_kms_key.vault_master_key[0].id : var.existing_masterkey_ocid
}