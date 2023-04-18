variable "OPENSSL_VERSION" {
    default = "3.1.0"
}
variable "ARIA2_VERSION" {
    default = "1.36.0"
}
variable "OUT_DIR" {
    default = "build"
}

variable "PLATFORMS" {
    default = "linux/amd64"
}

variable "OS_FLAVOUR" {
    default = "debian"
}

variable "OPENSSL_DIR_MAP" {
    default = {
        debian = "/etc/ssl"
        rhel = "/etc/pki/tls"
        suse = "/etc/ssl"
        arch = "/etc/ssl"
    }
}


target "default" {
    dockerfile = "Dockerfile" 
    args = {
        OPENSSL_VERSION = "${OPENSSL_VERSION}"
        ARIA2_VERSION = "${ARIA2_VERSION}"
        OPENSSL_DIR = lookup(OPENSSL_DIR_MAP, lower(OS_FLAVOUR), "/etc/ssl")
    }
    platforms = split(",", PLATFORMS)
    output = ["type=local,dest=${OUT_DIR}"]
}