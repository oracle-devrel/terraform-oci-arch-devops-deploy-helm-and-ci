## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


resource "oci_devops_build_pipeline_stage" "test_deploy_stage" {

  depends_on = [oci_devops_build_pipeline_stage.test_deliver_artifact_stage]

  #Required
  build_pipeline_id = oci_devops_build_pipeline.test_build_pipeline.id

  build_pipeline_stage_predecessor_collection {
    #Required
    items {
      #Required
      id = oci_devops_build_pipeline_stage.test_deliver_artifact_stage.id
    }
  }

  build_pipeline_stage_type = var.build_pipeline_stage_deploy_stage_type

  deploy_pipeline_id             = oci_devops_deploy_pipeline.test_deploy_pipeline.id
  display_name                   = "${var.app_name}_invoke_deployment"
  is_pass_all_parameters_enabled = var.build_pipeline_stage_is_pass_all_parameters_enabled
  defined_tags                   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}

#Invoke helm deployment


resource "oci_devops_build_pipeline_stage" "invoke_helm_deploy_stage" {

  depends_on = [oci_devops_build_pipeline_stage.helm_deliver_artifact_stage]

  #Required
  build_pipeline_id = oci_devops_build_pipeline.helm_build_pipeline.id

  build_pipeline_stage_predecessor_collection {
    #Required
    items {
      #Required
      id = oci_devops_build_pipeline_stage.helm_deliver_artifact_stage.id
    }
  }

  build_pipeline_stage_type = var.build_pipeline_stage_deploy_stage_type

  deploy_pipeline_id             = oci_devops_deploy_pipeline.helm_deploy_pipeline.id
  display_name                   = "${var.app_name}_invoke_deployment"
  is_pass_all_parameters_enabled = var.build_pipeline_stage_is_pass_all_parameters_enabled
  defined_tags                   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}