terraform {
  backend "gcs" {}
}

provider "google" {
  version = "~> 3.3"
}
