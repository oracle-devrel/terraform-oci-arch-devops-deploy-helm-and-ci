### Copyright (c) 2023, Oracle and/or its affiliates.
### All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
resource "oci_devops_trigger" "trigger_build" {
  defined_tags   =  { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  display_name   = "${var.app_name}_trigger_buildpipeline"
  freeform_tags  = {}
  project_id     = oci_devops_project.test_project.id
  repository_id  = oci_devops_repository.test_repository.id
  trigger_source = var.trigger_source

  actions {
    build_pipeline_id = oci_devops_build_pipeline.test_build_pipeline.id
    type              = "TRIGGER_BUILD_PIPELINE"

    filter {
      events         = var.trigger_events
      trigger_source = "DEVOPS_CODE_REPOSITORY"

      exclude {
        file_filter {
          file_paths = var.trigger_execlude_patterns
        }
      }

      include {
        file_filter {
          file_paths = var.trigger_include_patterns
        }
      }
    }
  }

  timeouts {}
  provisioner "local-exec" {
    command = "sleep 20"
  }
}
