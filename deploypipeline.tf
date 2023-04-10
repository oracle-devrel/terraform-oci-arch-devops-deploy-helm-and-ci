resource "oci_devops_deploy_pipeline" "test_deploy_pipeline" {
  depends_on = [oci_devops_build_pipeline.test_build_pipeline,module.oci-oke]
  #Required
  project_id   = oci_devops_project.test_project.id
  description  = var.deploy_pipeline_description
  display_name = "deploy_containerinstance_${random_id.tag.hex}"
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_devops_deploy_pipeline" "helm_deploy_pipeline" {
  depends_on = [oci_devops_build_pipeline.test_build_pipeline,module.oci-oke]
  #Required
  project_id   = oci_devops_project.test_project.id
  description  = var.deploy_pipeline_description
  display_name = "deploy_helmchart_${random_id.tag.hex}"
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}