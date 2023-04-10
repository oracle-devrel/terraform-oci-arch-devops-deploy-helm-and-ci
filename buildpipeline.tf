## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_build_pipeline" "test_build_pipeline" {
  project_id = oci_devops_project.test_project.id

  description  = var.build_pipeline_description
  display_name = "${var.app_name}_build_containerinstance"
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

  build_pipeline_parameters {
    items {
      name = "BUCKET_NAME"
      default_value = oci_objectstorage_bucket.Bucket.name
      description = "Objectstorage bucket name."
    }
    items {
      name = "NAMESPACE_NAME"
      default_value = oci_objectstorage_bucket.Bucket.namespace
      description = "Object storage namespace."
    }
    items {
      name = "SUBNET_OCID"
      default_value = oci_core_subnet.oke_k8s_endpoint_subnet[0].id
      description = "SubnetId."
    }
    items {
      name = "IMAGE_STATIC_TAG"
      default_value = var.image_static_tag
      description = "Static image name"
    }
    items {
      name = "CONTAINER_REGISTRY_URL"
      default_value = "${var.region}.ocir.io/${data.oci_objectstorage_namespace.ns.namespace}/${var.container_repo_name}"
      description = "Container image url."
    }
    items {
      name = "CONTAINERINSTANCE_DISPLAY_NAME"
      default_value = "${var.app_name}_containerinstance"
      description = "Container instance display name."
    }
    items {
      name = "AD"
      default_value = data.template_file.ad_names[0].rendered
      description = "Availability domain."
    }
    items {
      name = "COMPARTMENT_OCID"
      default_value = var.compartment_ocid
      description = "Compartment OCID."
    }
    items {
      name = "REGION"
      default_value = var.region
      description = "OCI Region."
    }
    items {
      name = "AWS_ACCESS_KEY_ID_OCID"
      default_value = oci_vault_secret.aws_access_key_id.id
      description = "aws access key id ocid."
    }
    items {
      name = "AWS_ACCESS_KEY_SECRET_OCID"
      default_value = oci_vault_secret.aws_access_key.id
      description = "aws access key secret ocid."
    }
  }
}

# Build pipeline for helm

resource "oci_devops_build_pipeline" "helm_build_pipeline" {
  project_id = oci_devops_project.test_project.id

  description  = var.build_pipeline_description
  display_name = "${var.app_name}_build_helmpackages"
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

  build_pipeline_parameters {
    items {
      name = "GPG_ARTIFACT_OCID"
      default_value = "dummy_ocid"
      description = "OCID of the artifact."
    }
    items {
      name = "HELM_SIGN_KEY"
      default_value = var.helm_sign_key
      description = "Helm chart sign in key."
    }
    items {
      name = "HELM_REGISTRY"
      default_value = "${var.region}.ocir.io"
      description = "Helm registry base url."
    }
    items {
      name = "HELM_CHART_REPO"
      default_value = var.helm_chart_repo
      description = "Static image name"
    }
    items {
      name = "HELM_REGISTRY_NAMESPACE"
      default_value = data.oci_objectstorage_namespace.ns.namespace
      description = "OCIR Name space."
    }
  }
}