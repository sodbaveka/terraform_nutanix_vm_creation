locals {
    current_timestamp = timestamp()
    current_day = formatdate("YYYY-MM-DD", local.current_timestamp)
}

# resource "nutanix_image" "nutanix_image_ubuntu" {
#   name        = "ubuntu_image_mdt"
#   description = "Ubuntu_Image_For_Nutanix"
#   source_uri  = "http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/current/images/netboot/mini.iso"
# }

data "nutanix_cluster" "cluster" {
  #name = var.cluster_name
  cluster_id = var.cluster_uuid
}

data "nutanix_subnet" "subnet" {
  subnet_name = var.subnet_name
}

resource "nutanix_virtual_machine" "vm" {
  name                 = "${var.vm_name}${local.current_timestamp}"
  cluster_uuid         = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket = "2"
  num_sockets          = "2"
  memory_size_mib      = 4096

  # disk_list {
  #   data_source_reference = {
  #     kind = "image"
  #     uuid = nutanix_image.nutanix_image_ubuntu.id
  #   }
  # }

  #This parent_reference is what actually tells the provider to clone the specified VM
  parent_reference = {
    kind = "vm"
    name = "111-debian12-MDT"
    uuid = "36201406-f484-48bf-b8ca-2f33fef257b8"
  }

  # disk_list {
  #   disk_size_bytes = 10 * 1024 * 1024 * 1024
  #   device_properties {
  #     device_type = "DISK"
  #     disk_address = {
  #       "adapter_type" = "SCSI"
  #       "device_index" = "1"
  #     }
  #   }
  # }
  #guest_customization_cloud_init_user_data = base64encode(file("./cloud-init_user-data.sh"))

  disk_list {

    data_source_reference = {
      kind = "vm"
      name = "111-debian12-MDT"
      uuid = "36201406-f484-48bf-b8ca-2f33fef257b8"
    }

    # # Do not touch this, cloning randomly adds a CDROM device and will break if you don't define it here
    # device_properties {
    #   device_type = "CDROM"
    #   disk_address = {
    #     device_index = 3
    #     adapter_type = "IDE"
    #   }
    # }

  }

  serial_port_list {
    index = 0
    is_connected = "true"
  }

  nic_list {
    subnet_uuid = var.subnet_uuid
    ip_endpoint_list {
      ip = var.vm_ip01
      type = "ASSIGNED"
    }
  }

  guest_customization_cloud_init_user_data = base64encode(templatefile("./cloud-init_user-data.sh", {
      hostname       = "${var.vm_name}${local.current_timestamp}"
      ipv4_address   = "${var.vm_ip01}"
      ipv4_gateway   = var.subnet_gw
      name_server    = var.subnet_dns
      new_user_name = var.new_user_name
      new_user_password = var.new_user_password
    }))
    
  #guest_customization_cloud_init_user_data = "${base64encode("${file("cloud-init_user-data.yml")}")}"

}

output "ip_address" {
  value = nutanix_virtual_machine.vm.nic_list_status.0.ip_endpoint_list[0]["ip"]
}

output "cluster_uuid" {
   value = data.nutanix_cluster.cluster.id
}

output "cluster_name" {
   value = data.nutanix_cluster.cluster.name
}