resource "rke_cluster" "cluster" {
  nodes {
    address          = esxi_guest.k8s-master01.ip_address
    internal_address = "192.168.101.4"
    user             = "kube"
    ssh_key          = file("~/.ssh/id_rsa.kube")
    role             = ["controlplane", "worker", "etcd"]
  }
  nodes {
    address          = esxi_guest.k8s-worker01.ip_address
    internal_address = "192.168.101.5"
    user             = "kube"
    ssh_key          = file("~/.ssh/id_rsa.kube")
    role             = ["worker"]
  }
  nodes {
    address          = esxi_guest.k8s-worker02.ip_address
    internal_address = "192.168.101.6"
    user             = "kube"
    ssh_key          = file("~/.ssh/id_rsa.kube")
    role             = ["worker"]
  }
  network {
    plugin = "flannel"
  }
}

resource "local_file" "kube_cluster_yaml" {
  filename = "kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}