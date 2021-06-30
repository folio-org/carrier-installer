provider "google" {
  project     = "${var.project_name}"
  zone        = "${var.zone}"
}

resource "google_compute_disk" "default" {
  name  = "carrier-disk"
  zone  = "${var.zone}"
  size = "${var.disk_size}"
}

resource "google_compute_attached_disk" "default" {
  disk     = google_compute_disk.default.id
  instance = google_compute_instance.vm_instance.id
}

resource "google_compute_firewall" "default" {
 name    = "carrier-firewall"
 network = google_compute_network.default.name

 allow {
   protocol = "tcp"
   ports    = ["22", "${var.traefik_port}", "8080", "8086", "3100", "4444", "5672"]
 }
}

resource "google_compute_network" "default" {
  name = "carrier-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "carrier"
  machine_type = "vmtype"

  tags = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "ostype"
    }
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }

  network_interface {
  network = google_compute_network.default.name

  access_config {}
  }

  metadata = {
    ssh-keys = "${var.account_name}:${file("/installer/gcp_install/id_rsa.pub")}"
  }
}
