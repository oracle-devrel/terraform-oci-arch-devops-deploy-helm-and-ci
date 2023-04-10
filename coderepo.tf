## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_repository" "test_repository" {
  #Required
  name       = "devops-coderepo-${var.app_name}"
  project_id = oci_devops_project.test_project.id

  #Optional
  default_branch = var.repository_default_branch
  description    = var.repository_description

  repository_type = var.repository_repository_type
}



resource "null_resource" "clone_from_ocicoderepo" {
  depends_on = [oci_devops_project.test_project,oci_devops_repository.test_repository]
  provisioner "local-exec" {
    command = <<-EOT
     echo "remove existing repo";
     rm -rf ${oci_devops_repository.test_repository.name}
     echo '(3) Starting git clone command... '; echo 'Username: Before' ${var.oci_user_name}; echo 'Username: After' ${local.encode_user}; echo 'auth_token' ${local.auth_token}; git clone https://${local.encode_user}:${local.auth_token}@devops.scmservice.${var.region}.oci.oraclecloud.com/namespaces/${local.ocir_namespace}/projects/${oci_devops_project.test_project.name}/repositories/${oci_devops_repository.test_repository.name};
     cp -pr config/* ${oci_devops_repository.test_repository.name}/
     cp -pr python_app ${oci_devops_repository.test_repository.name}/
     cp -pr helm_chart ${oci_devops_repository.test_repository.name}/
EOT
  }
}

resource "null_resource" "update_vault_ocid" {
  depends_on = [null_resource.clone_from_ocicoderepo,
                oci_devops_repository.test_repository]
  provisioner "local-exec" {
    command = <<-EOT
    echo "Updating Vault OCIds for Shell Stage..."
    sed  's/SECRET_aws_access_key_id/${oci_vault_secret.aws_access_key_id.id}/g' ${oci_devops_repository.test_repository.name}/command_spec.yaml >${oci_devops_repository.test_repository.name}/command_spec.yaml-tmp
    sed  's/SECRET_aws_secret_access_key/${oci_vault_secret.aws_access_key.id}/g' ${oci_devops_repository.test_repository.name}/command_spec.yaml-tmp >${oci_devops_repository.test_repository.name}/command_spec.yaml
    rm  ${oci_devops_repository.test_repository.name}/command_spec.yaml-*
    echo "Updating Vault OCIds for Helm Stage..."
    sed  's/SEC_Helm_Repo_User/${oci_vault_secret.helm_repo_user.id}/g' ${oci_devops_repository.test_repository.name}/helm_chart/build_spec.yaml >${oci_devops_repository.test_repository.name}/helm_chart/build_spec.yaml-1
    sed  's/SEC_User_Auth_Token/${oci_vault_secret.helm_repo_token.id}/g' ${oci_devops_repository.test_repository.name}/helm_chart/build_spec.yaml-1 >${oci_devops_repository.test_repository.name}/helm_chart/build_spec.yaml-2
    sed  's/SEC_Gpg_Passphrase/${oci_vault_secret.gpg_passphrase.id}/g' ${oci_devops_repository.test_repository.name}/helm_chart/build_spec.yaml-2 >${oci_devops_repository.test_repository.name}/helm_chart/build_spec.yaml
    rm ${oci_devops_repository.test_repository.name}/helm_chart/build_spec.yaml-*
   EOT
  }
}

resource "null_resource" "pushcode" {

  depends_on = [null_resource.clone_from_ocicoderepo,
                null_resource.update_vault_ocid,
                oci_devops_trigger.trigger_build]

  provisioner "local-exec" {
    command = "cd ./${oci_devops_repository.test_repository.name}; git config --global user.email 'test@example.com'; git config --global user.name '${var.oci_user_name}';git add .; git commit -m 'added latest files'; git push origin '${var.repository_default_branch}'"
  }
}

locals {
  encode_user = urlencode(var.oci_user_name)
  auth_token  = urlencode(var.oci_user_authtoken)
}