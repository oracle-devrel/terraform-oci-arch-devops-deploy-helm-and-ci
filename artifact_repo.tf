## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Create Artifact Repository

resource "oci_artifacts_repository" "test_repository" {
  #Required
  compartment_id  = var.compartment_ocid
  is_immutable    = false
  display_name    = "${var.app_name}_artifact_repo"
  repository_type = "GENERIC"
  defined_tags    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

