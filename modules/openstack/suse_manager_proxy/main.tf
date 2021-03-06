variable "images" {
  default = {
    "2.1-released" = "sles11sp3"
    "2.1-nightly" = "sles11sp3"
    "3.0-released" = "sles12sp1"
    "3.0-nightly" = "sles12sp1"
    "3.1-released" = "sles12sp2"
    "3.1-nightly" = "sles12sp2"
    "head" = "sles12sp3"
  }
}

module "suse_manager_proxy" {
  source = "../host"

  base_configuration = "${var.base_configuration}"
  name = "${var.name}"
  count = "${var.count}"
  additional_repos = "${var.additional_repos}"
  additional_packages = "${var.additional_packages}"
  ssh_key_path = "${var.ssh_key_path}"
  gpg_keys = "${var.gpg_keys}"
  grains = <<EOF

version: ${var.version}
mirror: ${var.base_configuration["mirror"]}
server: ${var.server_configuration["hostname"]}
role: suse_manager_proxy
for_development_only: ${var.for_development_only}
use_unreleased_updates: ${var.use_unreleased_updates}

EOF

  // Provider-specific variables
  image = "${lookup(var.images, var.version)}"
  flavor = "${var.flavor}"
  root_volume_size = "${var.root_volume_size}"
}

output "configuration" {
  value = "${module.suse_manager_proxy.configuration}"
}
