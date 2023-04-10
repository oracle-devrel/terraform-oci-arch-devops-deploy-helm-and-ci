# Copyright (c) 2023 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# objectstorage.tf
#
# Purpose: The following script defines the creation of an object storage
# Registry: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/objectstorage_bucket


resource "oci_objectstorage_bucket" "Bucket" {
  access_type    = var.bucket_access_type
  compartment_id = var.compartment_ocid

  metadata = {
  }
  namespace             = data.oci_objectstorage_namespace.ns.namespace
  name                  = "${var.app_name}_ObjectStorage"
  object_events_enabled = var.object_events_enabled
  storage_tier          = var.storage_tier
  versioning            = var.versioning
}