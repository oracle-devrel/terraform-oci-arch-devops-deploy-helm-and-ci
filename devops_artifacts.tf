resource "oci_devops_deploy_artifact" "docker_image_dynamic" {

  #Required
  argument_substitution_mode = var.deploy_artifact_argument_substitution_mode
  deploy_artifact_source {
    #Required
    deploy_artifact_source_type = var.docker_image_dynamic_source_type

    #Optional
    image_uri     = "${local.ocir_docker_repository}/${local.ocir_namespace}/${oci_artifacts_container_repository.test_container_repository_pythonapp.display_name}:$${BUILDRUN_HASH}"
    image_digest  = " "
    #image_digest  = oci_devops_build_run.test_build_run.build_outputs[0].delivered_artifacts[0].items[0].delivered_artifact_hash
    repository_id = oci_devops_repository.test_repository.id
  }

  deploy_artifact_type = var.ocker_image_dynamic_artifact_type
  project_id           = oci_devops_project.test_project.id

  #Optional
  display_name = "docker_image_dynamic"
}

resource "oci_devops_deploy_artifact" "docker_image_static" {

  #Required
  argument_substitution_mode = var.deploy_artifact_argument_substitution_mode
  deploy_artifact_source {
    #Required
    deploy_artifact_source_type = var.docker_image_dynamic_source_type

    #Optional
    image_uri     = "${local.ocir_docker_repository}/${local.ocir_namespace}/${oci_artifacts_container_repository.test_container_repository_pythonapp.display_name}:${var.image_static_tag}"
    image_digest  = " "
    #image_digest  = oci_devops_build_run.test_build_run.build_outputs[0].delivered_artifacts[0].items[0].delivered_artifact_hash
    repository_id = oci_devops_repository.test_repository.id
  }

  deploy_artifact_type = var.ocker_image_dynamic_artifact_type
  project_id           = oci_devops_project.test_project.id

  #Optional
  display_name = "docker_image_static"
}

resource "oci_devops_deploy_artifact" "command_spec_ga" {
  argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
  defined_tags               = {
    "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release
  }
  deploy_artifact_type       = "GENERIC_FILE"
  display_name               = "command_spec_ga"
  freeform_tags              = {}
  project_id                 = oci_devops_project.test_project.id

  deploy_artifact_source {
    deploy_artifact_path = var.devops_artifact_command_spec_ga_path
    deploy_artifact_source_type = "GENERIC_ARTIFACT"
    deploy_artifact_version = var.devops_artifact_command_spec_ga_version
    repository_id = oci_artifacts_repository.test_repository.id
  }
}

resource "oci_devops_deploy_artifact" "command_spec_cs" {
  argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
  defined_tags               = {
    "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release
  }
  deploy_artifact_type       = "COMMAND_SPEC"
  display_name               = "command_spec_cs"
  freeform_tags              = {}
  project_id                 = oci_devops_project.test_project.id

  deploy_artifact_source {
    deploy_artifact_path = var.devops_artifact_command_spec_ga_path
    deploy_artifact_source_type = "GENERIC_ARTIFACT"
    deploy_artifact_version = var.devops_artifact_command_spec_ga_version
    repository_id = oci_artifacts_repository.test_repository.id
  }
}

# oci_devops_deploy_artifact.helm_chart_package:
resource "oci_devops_deploy_artifact" "helm_chart_package" {
  argument_substitution_mode = "NONE"
  defined_tags               = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release}
  deploy_artifact_type       = "HELM_CHART"
  display_name               = "node_helm_package"
  freeform_tags              = {}
  project_id                 = oci_devops_project.test_project.id
  deploy_artifact_source {
    chart_url                   = "oci://${var.region}.ocir.io/${data.oci_objectstorage_namespace.ns.namespace}/${var.helm_chart_repo}/node-service"
    deploy_artifact_source_type = "HELM_CHART"
    deploy_artifact_version     = "${var.helm_chart_version}-$${BUILDRUN_HASH}"

    helm_verification_key_source {
      vault_secret_id              = oci_vault_secret.gpg_pub_key.id
      verification_key_source_type = "VAULT_SECRET"
    }
  }

  timeouts {}
}

resource "oci_devops_deploy_artifact" "docker_image_dynamic_helm" {

  #Required
  argument_substitution_mode = var.deploy_artifact_argument_substitution_mode
  deploy_artifact_source {
    #Required
    deploy_artifact_source_type = var.docker_image_dynamic_source_type

    #Optional
    image_uri     = "${local.ocir_docker_repository}/${local.ocir_namespace}/${oci_artifacts_container_repository.test_container_repository_helm.display_name}:$${BUILDRUN_HASH}"
    image_digest  = " "
    #image_digest  = oci_devops_build_run.test_build_run.build_outputs[0].delivered_artifacts[0].items[0].delivered_artifact_hash
    repository_id = oci_devops_repository.test_repository.id
  }

  deploy_artifact_type = var.ocker_image_dynamic_artifact_type
  project_id           = oci_devops_project.test_project.id

  #Optional
  display_name = "docker_image_for_helm"
}