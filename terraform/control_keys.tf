resource "google_kms_key_ring" "chatstatz_control_key_ring" {
  name     = "chatstatz-control-key-ring"
  location = "global"
  project  = "chatstatz-control"
}

# For enrypting Terrform state files. See https://github.com/chatstatz/tfstate.
resource "google_kms_crypto_key" "chatstatz_control_tfstate_key" {
  name            = "chatstatz-control-tfstate-key"
  key_ring        = google_kms_key_ring.chatstatz_control_key_ring.self_link
  rotation_period = "7776000s" # 90 days (86400 x 90)

  lifecycle {
    # Note: CryptoKeys cannot be deleted from Google Cloud Platform. Destroying a Terraform-managed CryptoKey
    # will remove it from state and delete all CryptoKeyVersions, rendering the key unusable, but will
    # not delete the resource on the server. When Terraform destroys these keys, any data previously
    # encrypted with these keys will be irrecoverable. For this reason, it is strongly recommended that
    # you add lifecycle hooks to the resource to prevent accidental destruction.
    prevent_destroy = true
  }

  labels = {
    project    = "chatstatz-control"
    repository = local.repository
    stage      = "control"
    slice      = var.slice
    region     = "global"
    managed-by = "terraform"
  }
}
