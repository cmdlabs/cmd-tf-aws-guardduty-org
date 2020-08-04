module "guardduty" {
  source = "../"

  bucket_name           = "cmdlabtf-master-guardduty-storage"
  force_destroy         = true
  detector_enable       = true
  ipset_format          = "TXT"
  ipset_iplist          = ["1.1.1.1", "2.2.2.2", ]
  threatintelset_format = "TXT"
  threatintelset_iplist = ["3.3.3.3", "4.4.4.4", ]

}

output "detector_id" {
  description = "The ID of the GuardDuty detector"
  value       = module.guardduty.detector_id
}