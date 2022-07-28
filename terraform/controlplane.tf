resource "libvirt_volume" "kubernetes-server" {
  count          = length(var.kubernetes_server_ips)
  name           = "kubernetes-server-${count.index}"
  base_volume_id = libvirt_volume.os_image_ubuntu.id
  pool           = libvirt_pool.kubernetes.name
  size           = var.kubernetes_server_disk_size
  format         = "qcow2"
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "server-init" {
  count = length(var.kubernetes_server_ips)
  name  = "server-init-${count.index}.iso"
  pool  = libvirt_pool.kubernetes.name
  user_data = templatefile("${path.cwd}/templates/controlplane.cfg",
    {
      HOSTNAME = upper(format(
        "%v-%v",
        var.kubernetes_server_name,
        count.index
      )),
      KUBERNETES_SERVER_COUNT         = length(var.kubernetes_server_ips),
      KUBERNETES_SERVER_JOIN_IP       = element(var.kubernetes_server_ips, 0),
      KUBERNETES_SERVER_ENABLE_CLIENT = var.kubernetes_server_enable_client,
      KUBERNETES_NODE_PUBLIC_KEY      = file(var.kubernetes_node_public_key_path),
      KUBERNETES_NODE_SSH_USERNAME    = var.kubernetes_node_ssh_username,
      KUBERNETES_JOIN_TOKEN           = var.kubernetes_join_token,
      KUBERNETES_NODES_IPS            = join(",", var.kubernetes_worker_ips),
      KUBERNETES_MASTER_IPS           = join(",", setsubtract(var.kubernetes_server_ips, [element(var.kubernetes_server_ips, count.index)])),
  })

}


# Create the machine
resource "libvirt_domain" "domain-kubernetes-server" {
  count  = length(var.kubernetes_server_ips)
  name   = "${var.kubernetes_server_name}-${count.index}"
  memory = var.kubernetes_server_memory
  vcpu   = var.kubernetes_server_vcpu

  cloudinit = libvirt_cloudinit_disk.server-init[count.index].id

  network_interface {
    network_id     = libvirt_network.kubernetes_network.id
    hostname       = "${var.kubernetes_server_name}-${count.index}"
    addresses      = [element(var.kubernetes_server_ips, count.index)]
    wait_for_lease = true
  }


  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.kubernetes-server[count.index].id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "remote-exec" {
    connection {
      host  = self.network_interface.0.addresses.0
      type  = "ssh"
      user  = var.kubernetes_node_ssh_username
      agent = true
    }
    inline = [
      "cloud-init status --wait  > /dev/null 2>&1",
    ]
  }
}