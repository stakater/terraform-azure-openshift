provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "platform_domain_administrator" {
  algorithm = "RSA"
}

resource "acme_registration" "platform_domain_administrator" {
  account_key_pem = "${tls_private_key.platform_domain_administrator.private_key_pem}"
  email_address   = "${var.platform-domain-administrator-email}"
}

resource "tls_private_key" "platform_domain_csr" {
  algorithm = "RSA"
}

resource "tls_cert_request" "platform_domain" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.platform_domain_csr.private_key_pem}"

  dns_names = ["${var.platform-domain}"]

  subject {
    common_name = "*.${var.platform-domain}"
  }
}

resource "acme_certificate" "platform_domain" {
  account_key_pem         = "${acme_registration.platform_domain_administrator.account_key_pem}"
  certificate_request_pem = "${tls_cert_request.platform_domain.cert_request_pem}"

  dns_challenge {
    provider = "azure"
    config = {
      AZURE_CLIENT_ID = "${var.azure-client-id}"
      AZURE_CLIENT_SECRET = "${var.azure-client-secret}"
      AZURE_RESOURCE_GROUP = "${var.azure-resource-group}"
      AZURE_SUBSCRIPTION_ID = "${var.azure-subscription-id}"
      AZURE_TENANT_ID = "${var.azure-tenant-id}"
    }
  }
}
