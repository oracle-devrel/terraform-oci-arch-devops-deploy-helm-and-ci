## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_deploy_stage" "shellstage_ci_deploy_stage" {
  command_spec_deploy_artifact_id = oci_devops_deploy_artifact.command_spec_cs.id
  defined_tags                    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  deploy_pipeline_id              = oci_devops_deploy_pipeline.test_deploy_pipeline.id
  deploy_stage_type               = "SHELL"
  display_name                    = "${var.app_name}_shell_stage"
  freeform_tags                   = {}

  container_config {
    availability_domain   = data.template_file.ad_names[0].rendered
    container_config_type = "CONTAINER_INSTANCE_CONFIG"
    shape_name            = var.shellstage_shape

    network_channel {
      network_channel_type = "SERVICE_VNIC_CHANNEL"
      nsg_ids              = []
      subnet_id            = oci_core_subnet.oke_nodes_subnet[0].id
    }

    shape_config {
      memory_in_gbs = var.shellstage_memory_in_gbs
      ocpus         = var.shellstage_ocpus
    }
  }

  deploy_stage_predecessor_collection {
    items {
      id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    }
  }

  timeouts {}
}
