provider "aws" {
  version                 = ">= 2.65"
  profile                 = "cmdlabtf-sandpit"
  region                  = "ap-southeast-2"
  skip_metadata_api_check = true
}
