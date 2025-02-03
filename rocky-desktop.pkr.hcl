packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "vm_version" {
  type        = string
  default     = "1.0.2"
  description = "Version of OVA"
}

variable "vm_name" {
  type        = string
  default     = "rocky-desktop"
  description = "Prefix for VM name"
}

variable "vm_description" {
  type        = string
  default     = "Rocky Linux 9 with GNOME"
  description = "VM description"
}

variable "guest_os_username" {
  type        = string
  default     = "user"
  description = "Name of guest OS user"
}

variable "guest_os_password" {
  type        = string
  default     = "user"
  description = "Password of guest OS user"
}

source "virtualbox-iso" "rocky-desktop" {
  vm_name = "${var.vm_name}-${var.vm_version}"
  export_opts = [
    "--manifest",
    "--vsys", "0",
    "--description", "${var.vm_description}",
    "--version", "${var.vm_version}"
  ]
  format        = "ova"
  guest_os_type = "RedHat9_64"
  headless      = false
  http_content = {
    "/ks.cfg" = templatefile("src/templates/http/ks.cfg.pkrtpl.hcl", {
      username = var.guest_os_username
      password = var.guest_os_password
    })
  }
  iso_url                = "Rocky-9.5-x86_64-dvd.iso"
  iso_checksum           = "sha256:ba60c3653640b5747610ddfb4d09520529bef2d1d83c1feb86b0c84dff31e04e"
  guest_additions_url    = "VBoxGuestAdditions_7.1.6.iso"
  guest_additions_sha256 = "dbbda1645bc05c9260adfe9efc4949cb590ec5ec02680aff936375670cffcafc"
  guest_additions_path   = "VBoxGuestAdditions.iso"
  boot_command = [
    "<up><wait><tab> inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
  ]
  boot_wait            = "30s"
  shutdown_command     = "echo '${var.guest_os_username}' | sudo -S /sbin/halt -h -p"
  post_shutdown_delay  = "30s"
  ssh_username         = var.guest_os_username
  ssh_password         = var.guest_os_password
  ssh_wait_timeout     = "10000s"
  cpus                 = 4
  memory               = 4096
  rtc_time_base        = "UTC"
  gfx_controller       = "vmsvga"
  gfx_vram_size        = 128
  hard_drive_interface = "sata"
  sata_port_count      = 4
  disk_size            = 81920
  sound                = "default"
  output_directory     = "output"
  skip_export          = "false"
  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--vrde", "off"],
    ["modifyvm", "{{ .Name }}", "--clipboard-mode", "bidirectional"],
    ["modifyvm", "{{ .Name }}", "--draganddrop", "disabled"],
    ["modifyvm", "{{ .Name }}", "--audioout", "on"],
    ["modifyvm", "{{ .Name }}", "--usbehci", "on"],
    ["modifyvm", "{{ .Name }}", "--nat-localhostreachable1", "on"],
    ["modifyvm", "{{ .Name }}", "--natdnshostresolver1", "on"]
  ]
  vboxmanage_post = [
    ["storagectl", "{{ .Name }}", "--name", "IDE Controller", "--rename", "IDE"],
    ["storagectl", "{{ .Name }}", "--name", "SATA Controller", "--rename", "SATA"],
    ["storageattach", "{{ .Name }}", "--storagectl", "IDE", "--port", "0", "--device", "0", "--medium", "emptydrive"]
  ]
  virtualbox_version_file = ""
}

build {
  sources = ["virtualbox-iso.rocky-desktop"]
  provisioner "shell" {
    execute_command = "echo '${var.guest_os_password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    scripts = [
      "src/scripts/update.sh"
    ]
  }
  provisioner "shell" {
    execute_command = "echo '${var.guest_os_password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    inline = ["reboot"]
    expect_disconnect = true
    pause_after = "60s"
  }
  provisioner "shell" {
    execute_command = "echo '${var.guest_os_password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    environment_vars = [
      "SSH_USER=${var.guest_os_username}",
      "VBOXSF_USER=${var.guest_os_username}",
      "GNOME_USER=${var.guest_os_username}"
    ]
    scripts = [
      "src/scripts/virtualbox.sh",
      "src/scripts/vagrant.sh",
      "src/scripts/gnome.sh",
      "src/scripts/cleanup.sh"
    ]
  }
}
