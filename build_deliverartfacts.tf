## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_build_pipeline_stage" "test_deliver_artifact_stage" {

  depends_on = [oci_devops_build_pipeline_stage.test_build_pipeline_stage]

  #Required
  build_pipeline_id = oci_devops_build_pipeline.test_build_pipeline.id
  build_pipeline_stage_predecessor_collection {
    #Required
    items {
      #Required
      id = oci_devops_build_pipeline_stage.test_build_pipeline_stage.id
    }
  }

  build_pipeline_stage_type = var.build_pipeline_stage_deliver_artifact_stage_type

  deliver_artifact_collection {
    items {
      artifact_id   = oci_devops_deploy_artifact.command_spec_ga.id
      artifact_name = var.deliver_command_spec_artifact_name
    }
    items {
      artifact_id   = oci_devops_deploy_artifact.docker_image_dynamic.id
      artifact_name = var.deliver_artiifact_docker_image_dynamic_name
    }
    items {
      artifact_id   = oci_devops_deploy_artifact.docker_image_static.id
      artifact_name = var.deliver_artiifact_docker_image_static_name
    }
  }
  display_name = var.deliver_artifact_stage_display_name
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}

#Deliver artifact for helm
resource "oci_devops_build_pipeline_stage" "helm_deliver_artifact_stage" {

  depends_on = [oci_devops_build_pipeline_stage.helm_build_pipeline_stage]

  #Required
  build_pipeline_id = oci_devops_build_pipeline.helm_build_pipeline.id
  build_pipeline_stage_predecessor_collection {
    #Required
    items {
      #Required
      id = oci_devops_build_pipeline_stage.helm_build_pipeline_stage.id
    }
  }

  build_pipeline_stage_type = var.build_pipeline_stage_deliver_artifact_stage_type

  deliver_artifact_collection {
    items {
      artifact_id   = oci_devops_deploy_artifact.docker_image_dynamic_helm.id
      artifact_name = var.deliver_command_spec_artifact_name_helm
    }

  }
  display_name = var.deliver_artifact_stage_display_name
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}
