listener "tcp" {
    address = "0.0.0.0:8200"
    tls_disable = true
}

storage "raft" {
    path = "./data"
    node_id = "node1"
}

disable_mlock = true

api_addr = "http://127.0.0.1:8200"
cluster_addr = "http://127.0.0.1:8201"
ui = true
