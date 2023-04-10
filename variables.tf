## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable oci_user_name {
  default = ""
}

variable oci_user_authtoken {
  default = ""
}

variable "aws_access_key" {
  default = ""
}

variable "aws_access_key_id" {
  default = ""
}

variable "app_name" {
  default     = "ociDevops"
  description = "Application name. Will be used as prefix to identify resources, such as OKE, VCN, DevOps, and others"
}

variable "gpg_passphrase" {
  default = ""
  description = "gpg passphrase public key"
}
variable "helm_sign_key" {
  default = "oci_devops"
}
variable "helm_chart_repo" {
  default = "node-helm-package"
}
locals {
  ocir_docker_repository = join("", [lower(lookup(data.oci_identity_regions.current_region.regions[0], "key")), ".ocir.io"])
  ocir_namespace = lookup(data.oci_objectstorage_namespace.ns, "namespace")
}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "0.0"
}

## Devops related variables
variable "helm_release_name" {
  default = "ocidevops"
}
variable "build_runner_type" {
  default = "CUSTOM"
}
variable "build_pipeline_stage_build_runner_shape_config_memory_in_gbs" {
  default = 8
}
variable "build_pipeline_stage_build_runner_shape_config_ocpus" {
  default = 2
}
variable "helm_chart_version" {
  default = "0.1.0"
}
variable "project_description" {
  description = "Devops project description"
  default = "OCI Devops project features"
}

variable "project_logging_config_retention_period_in_days" {
  default = 30
}
 variable "build_pipeline_description" {
   default = "OCI Build pipeline"
 }

variable "deploy_pipeline_description" {
  default = "OCI Deploy pipeline"
}

variable "repository_default_branch" {
  default = "main"
}

variable "repository_description" {
  default = "oci_devops_canary sample application"
}


variable "repository_repository_type" {
  default = "HOSTED"
}

variable "image_static_tag" {
  default = "new"
  description = "A static tag for container image deployment"
}
variable "build_pipeline_stage_build_pipeline_stage_type" {
  default = "BUILD"
}
variable "build_pipeline_stage_build_source_collection_items_connection_type" {
  default = "DEVOPS_CODE_REPOSITORY"
}
variable "build_pipeline_stage_build_source_collection_items_branch" {
  default = "main"
}
variable "build_pipeline_stage_build_source_collection_items_name" {
  default = "build_apps"
}
variable "build_pipeline_stage_build_spec_file" {
  default = ""
}
variable "build_pipeline_stage_display_name" {
  default = "Build Applications"
}

variable "build_pipeline_stage_image" {
  default = "OL7_X86_64_STANDARD_10"
}
variable "build_pipeline_stage_stage_execution_timeout_in_seconds" {
  default = 36000
}
variable "build_pipeline_stage_wait_criteria_wait_duration" {
  default = "waitDuration"
}

variable "build_pipeline_stage_wait_criteria_wait_type" {
  default = "ABSOLUTE_WAIT"
}
variable "deploy_artifact_argument_substitution_mode" {
  default = "SUBSTITUTE_PLACEHOLDERS"
}
variable "docker_image_dynamic_source_type" {
  default = "OCIR"
}
variable "ocker_image_dynamic_artifact_type" {
    default = "DOCKER_IMAGE"
}
variable "devops_artifact_command_spec_ga_path" {
  default = "commad_spec.yaml"
}
variable "devops_artifact_command_spec_ga_version" {
  default = "0.0"
}
variable "build_pipeline_stage_deliver_artifact_stage_type" {
  default = "DELIVER_ARTIFACT"
}
variable "deliver_command_spec_artifact_name" {
  default = "command_spec"
}
variable "deliver_command_spec_artifact_name_helm" {
  default = "APPLICATION_DOCKER_IMAGE"
}
variable "deliver_artifact_stage_display_name" {
  default = "Upload Artifacts"
}
variable "deliver_artiifact_docker_image_dynamic_name" {
  default = "container_instance_app_dockerimage"
}
variable "deliver_artiifact_docker_image_static_name" {
  default = "container_instance_app_dockerimage"
}
variable "shellstage_shape" {
  default = "CI.Standard.E4.Flex"
}
variable "shellstage_memory_in_gbs" {
  default = 1
}
variable "shellstage_ocpus" {
  default = 1
}
variable "build_pipeline_stage_deploy_stage_type" {
  default = "TRIGGER_DEPLOYMENT_PIPELINE"
}
variable "build_pipeline_stage_is_pass_all_parameters_enabled" {
  default = true
}
variable "trigger_source" {
  default = "DEVOPS_CODE_REPOSITORY"
}
variable "trigger_events" {
  default = ["PUSH",]
}
variable "trigger_execlude_patterns" {
  default = ["*.md",]
}
variable "trigger_include_patterns" {
  type = list
  default = ["*.tf", "*.yaml", "python_app/*", "helm_chart/*"]
}
variable "number_of_approvals_required" {
  default = 1
}
## Devops related variables

## Objectstorage related variables

variable "bucket_access_type" {
  description = "(Optional) (Updatable) The type of public access enabled on this bucket. A bucket is set to NoPublicAccess by default, which only allows an authenticated caller to access the bucket and its contents. When ObjectRead is enabled on the bucket, public access is allowed for the GetObject, HeadObject, and ListObjects operations. When ObjectReadWithoutList is enabled on the bucket, public access is allowed for the GetObject and HeadObject operations."
  default     = "NoPublicAccess"
}
variable "object_events_enabled" {
  description = "Whether or not events are emitted for object state changes in this bucket. By default, objectEventsEnabled is set to false. Set objectEventsEnabled to true to emit events for object state changes. For more information about events, see Overview of Events."
  type        = bool
  default     = false
}
variable "storage_tier" {
  description = "The storage tier type assigned to the bucket. A bucket is set to 'Standard' tier by default, which means objects uploaded or copied to the bucket will be in the standard storage tier. When the 'Archive' tier type is set explicitly for a bucket, objects uploaded or copied to the bucket will be stored in archive storage. The 'storageTier' property is immutable after bucket is created."
  default     = "Standard"
}
variable "versioning" {
  description = "The versioning status on the bucket. A bucket is created with versioning Disabled by default. For versioning Enabled, objects are protected from overwrites and deletes, by maintaining their version history. When versioning is Suspended, the previous versions will still remain but new versions will no longer be created when overwitten or deleted."
  default     = "Enabled"
}
## Objectstorage related variables
## Vault related variables
variable "create_new_vault" {
  type = bool
  default     = true
  description = "Creates a new vault"
}
variable "existing_vault_ocid" {
  default = ""
}
variable "existing_masterkey_ocid" {
  default = ""
}
variable "vault_vault_type" {
  default = "DEFAULT"
}
variable "vault_key_shape_algorithm" {
  default = "AES"
}
variable "key_key_shape_length" {
  default = 32
}
variable "vault_key_protection_mode" {
  default = "HSM"
}
## Vault related variables
## Container instance variables

## Container instance variables

## Container repo variables
variable "container_repository_is_public" {
  default = true
}
variable "container_repo_name" {
  default = "devopspythonrepo"
}
variable "container_repo_name_helm" {
  default = "devopshelmrepo"
}
## Container repo variables