## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_build_pipeline_stage" "test_build_pipeline_stage" {
  #Required
  build_pipeline_id = oci_devops_build_pipeline.test_build_pipeline.id
  build_pipeline_stage_predecessor_collection {
    #Required
    items {
      #Required
      id = oci_devops_build_pipeline.test_build_pipeline.id
    }
  }
  build_pipeline_stage_type = var.build_pipeline_stage_build_pipeline_stage_type

  #Optional
  build_source_collection {

    #Optional
    items {
      #Required
      connection_type = var.build_pipeline_stage_build_source_collection_items_connection_type

      #Optional
      branch = var.build_pipeline_stage_build_source_collection_items_branch
      # connection_id  = oci_devops_connection.test_connection.id
      name           = var.build_pipeline_stage_build_source_collection_items_name
      repository_id  = oci_devops_repository.test_repository.id
      repository_url = "https://devops.scmservice.${var.region}.oci.oraclecloud.com/namespaces/${local.ocir_namespace}/projects/${oci_devops_project.test_project.name}/repositories/${oci_devops_repository.test_repository.name}"
    }
  }

  build_spec_file = var.build_pipeline_stage_build_spec_file

  display_name                       = var.build_pipeline_stage_display_name
  image                              = var.build_pipeline_stage_image
  stage_execution_timeout_in_seconds = var.build_pipeline_stage_stage_execution_timeout_in_seconds
  wait_criteria {
    #Required
    wait_duration = var.build_pipeline_stage_wait_criteria_wait_duration
    wait_type     = var.build_pipeline_stage_wait_criteria_wait_type
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}

# oci_devops_build_pipeline_stage.helm_build_pipeline_stage:
resource "oci_devops_build_pipeline_stage" "helm_build_pipeline_stage" {
  build_pipeline_id                  = oci_devops_build_pipeline.helm_build_pipeline.id
  build_pipeline_stage_type          = "BUILD"
  build_spec_file                    = "helm_chart/build_spec.yaml"
  defined_tags                       = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release}
  display_name                       = "build_a_signed_helm_package"
  image                              = var.build_pipeline_stage_image
  stage_execution_timeout_in_seconds = var.build_pipeline_stage_stage_execution_timeout_in_seconds
  build_pipeline_stage_predecessor_collection {
    items {
      id = oci_devops_build_pipeline.helm_build_pipeline.id
    }
  }
  build_runner_shape_config {
    #Required
    build_runner_type = var.build_runner_type

    #Optional
    memory_in_gbs = var.build_pipeline_stage_build_runner_shape_config_memory_in_gbs
    ocpus = var.build_pipeline_stage_build_runner_shape_config_ocpus
  }
  build_source_collection {
    items {
      branch          = var.build_pipeline_stage_build_source_collection_items_branch
      connection_type = var.build_pipeline_stage_build_source_collection_items_connection_type
      name            = var.build_pipeline_stage_build_source_collection_items_name
      repository_id   = oci_devops_repository.test_repository.id
      repository_url  = "https://devops.scmservice.${var.region}.oci.oraclecloud.com/namespaces/${local.ocir_namespace}/projects/${oci_devops_project.test_project.name}/repositories/${oci_devops_repository.test_repository.name}"
    }
  }

  timeouts {}
}
