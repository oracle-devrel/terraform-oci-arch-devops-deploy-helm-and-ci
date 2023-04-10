resource "oci_artifacts_container_repository" "test_container_repository_pythonapp" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = var.container_repo_name
  #Optional
  is_public = var.container_repository_is_public
}

resource "oci_artifacts_container_repository" "test_container_repository_helm_package" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = "${var.helm_chart_repo}/node-service"
  #Optional
  is_public = var.container_repository_is_public
}

resource "oci_artifacts_container_repository" "test_container_repository_helm" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = var.container_repo_name_helm
  #Optional
  is_public = var.container_repository_is_public
}