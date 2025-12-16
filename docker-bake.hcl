variable "APP" {
  default = "ghcr.io/VijayakumarRavi/autopgbackrest"
}

variable "SUPERCRONIC_VERSION" {
  # renovate: datasource=github-releases depName=aptible/supercronic
  default = "v0.2.36"
}

variable "SOURCE" {
  default = "https://github.com/VijayakumarRavi/autopgbackrest"
}

variable "PG_TAGS" {
  default = [
    # v18
    "18.1", "18", "latest", 
    # "18.1-trixie", "18-trixie", "trixie",
    # "18.1-bookworm", "18-bookworm", "bookworm",
    
    # v17
    "17.7", "17", 
    # "17.7-trixie", "17-trixie",
    # "17.7-bookworm", "17-bookworm",

    # v16
    "16.11", "16", 
    # "16.11-trixie", "16-trixie",
    # "16.11-bookworm", "16-bookworm",

    # v15
    "15.15", "15", 
    # "15.15-trixie", "15-trixie",
    # "15.15-bookworm", "15-bookworm",

    # v14
    "14.20", "14", 
    # "14.20-trixie", "14-trixie",
    # "14.20-bookworm", "14-bookworm"
  ]
}

group "default" {
  targets = ["image"]
}

target "image" {
  name = "image-${replace(tag, ".", "-")}"
  matrix = {
    tag = PG_TAGS
  }
  
  args = {
    POSTGRES_TAG = "${tag}"
    SUPERCRONIC_VERSION = "${SUPERCRONIC_VERSION}"
  }
  
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
    "org.opencontainers.image.base.name" = "docker.io/library/postgres:${tag}"
    "org.opencontainers.image.version" = "${tag}"
    "org.opencontainers.image.description" = "Automated pgBackRest Docker image for PostgreSQL ${tag}"
  }

  tags = ["${APP}:${tag}"]
  platforms = [
    "linux/amd64",
    "linux/arm64",
    "linux/arm/v7"
  ]
}