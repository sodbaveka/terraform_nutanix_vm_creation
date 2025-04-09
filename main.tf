locals {
    current_timestamp = timestamp()
    current_day = formatdate("YYYY-MM-DD", local.current_timestamp)
}

resource "nutanix_image" "nutanix_image_ubuntu" {
  name        = "ubuntu_image_mdt"
  description = "Ubuntu_Image_For_Nutanix"
  source_uri  = "http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/current/images/netboot/mini.iso"
}

data "nutanix_cluster" "cluster" {
  name = var.cluster_name
}

data "nutanix_subnet" "subnet" {
  subnet_name = var.subnet_name
}

resource "nutanix_virtual_machine" "vm" {
  name                 = "${var.vm_name}${local.current_day}"
  cluster_uuid         = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket = "2"
  num_sockets          = "1"
  memory_size_mib      = 4096

  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = nutanix_image.nutanix_image_ubuntu.id
    }
  }

  disk_list {
    disk_size_bytes = 10 * 1024 * 1024 * 1024
    device_properties {
      device_type = "DISK"
      disk_address = {
        "adapter_type" = "SCSI"
        "device_index" = "1"
      }
    }
  }

  nic_list {
    subnet_uuid = var.subnet_uuid
    ip_endpoint_list {
      ip = var.vm_ip01
      type = "ASSIGNED"
    }
  }

}

output "ip_address" {
  value = nutanix_virtual_machine.vm.nic_list_status.0.ip_endpoint_list[0]["ip"]
}