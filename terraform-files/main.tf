terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.23.0"
    }
    # The template provider is defined here.
    # Below format of user_data requires template provider which has been archived by Hashicorp.
    # Hashicorp now suggests to use templatefile() or cloudinit provider instead.
    #user_data = data.template_file.bastion-server-init.rendered
    /*
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    */
    # As it was downloaded due to init command, I manually deleted it from .terraform folder and commented it above.
  }
}
