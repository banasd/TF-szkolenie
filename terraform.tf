# terraform.tf lub version.tf
 terraform {
   required_version = ">= 1.0.0"
   required_providers {
     digitalocean = {
        source = "digitalocean/digitalocean"
        version = "2.68.0"
     }
     tls = {
      source = "hashicorp/tls"
      version = "4.1.0"
     }
   }
 }