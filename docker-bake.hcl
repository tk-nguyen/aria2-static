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

target "default" {
    dockerfile = "Dockerfile" 
    args = {
        OPENSSL_VERSION = "${OPENSSL_VERSION}"
        ARIA2_VERSION = "${ARIA2_VERSION}"
    }
    platforms = split(",", PLATFORMS)
    output = ["type=local,dest=${OUT_DIR}"]
}