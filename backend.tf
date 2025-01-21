terraform {

  backend "s3" {

    bucket = "314137026201-forta-worktest-tfstate"
    key    = "state/terraform.tfstate"
    region = "eu-west-2"

  }

}
