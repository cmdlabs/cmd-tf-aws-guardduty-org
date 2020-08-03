variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to use"
  default     = ""
}

variable "force_destroy" {
  type        = bool
  description = "(Optional) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = false
}

variable "detector_enable" {
  type        = bool
  description = "Enable monitoring and feedback reporting"
  default     = true
}

variable "ipset_format" {
  type        = string
  description = "The format of the file that contains the IPSet"
  default     = "TXT"
}

variable "ipset_iplist" {
  type        = list
  description = "IPSet list of trusted IP addresses"
  default     = []
}

variable "threatintelset_format" {
  type        = string
  description = "The format of the file that contains the ThreatIntelSet"
  default     = "TXT"
}

variable "threatintelset_iplist" {
  type        = list
  description = "ThreatIntelSet list of known malicious IP addresses"
  default     = []
}
