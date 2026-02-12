variable "domainName" {
  type = string
}
variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}
