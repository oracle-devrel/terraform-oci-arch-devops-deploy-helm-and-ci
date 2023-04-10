## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# oci_devops_deploy_stage.helm_deploy_stage:
resource "oci_devops_deploy_stage" "helm_deploy_stage" {
  are_hooks_enabled                 = false
  defined_tags                      = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release}
  deploy_pipeline_id                = oci_devops_deploy_pipeline.helm_deploy_pipeline.id
  deploy_stage_type                 = "OKE_HELM_CHART_DEPLOYMENT"
  description                       = "deploy helm chart"
  display_name                      = "Deploy Helm Chart"
  freeform_tags                     = {}
  helm_chart_deploy_artifact_id     = oci_devops_deploy_artifact.helm_chart_package.id
  max_history                       = 5
  namespace                         = "default"
  oke_cluster_deploy_environment_id = oci_devops_deploy_environment.test_environment.id
  release_name                      = var.helm_release_name
  should_cleanup_on_fail            = false
  should_not_wait                   = false
  should_reset_values               = false
  should_reuse_values               = false
  should_skip_crds                  = false
  should_skip_render_subchart_notes = true

  deploy_stage_predecessor_collection {
    items {
      id = oci_devops_deploy_pipeline.helm_deploy_pipeline.id
    }
  }

  rollback_policy {
    policy_type = "AUTOMATED_STAGE_ROLLBACK_POLICY"
  }

  set_values {
    items {
      name  = "image.repository"
      value = "${var.region}.ocir.io/${data.oci_objectstorage_namespace.ns.namespace}/${oci_artifacts_container_repository.test_container_repository_helm.display_name}"
    }
  }

  timeouts {}
}
