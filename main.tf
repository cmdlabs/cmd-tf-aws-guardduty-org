resource "aws_guardduty_organization_admin_account" "admin" {
  admin_account_id = data.aws_organizations_organization.org.master_account_id
}

resource "aws_guardduty_detector" "detector" {
  enable = var.detector_enable
}

resource "aws_guardduty_organization_configuration" "org" {
  auto_enable = true
  detector_id = aws_guardduty_detector.detector.id
}

resource "aws_s3_bucket" "bucket" {
  count  = var.bucket_name == "" ? 0 : 1
  bucket = var.bucket_name
  versioning {
    enabled = true
  }
  policy        = data.aws_iam_policy_document.s3_policy.json
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_object" "ipset" {
  count = var.bucket_name == "" || var.ipset_iplist == [] ? 0 : 1
  acl   = "public-read"
  content = templatefile("${path.module}/templates/ipset.txt.tpl",
  { ipset_iplist = var.ipset_iplist })
  bucket = aws_s3_bucket.bucket[0].id
  key    = local.ipset_key
}

resource "aws_guardduty_ipset" "ipset" {
  count       = var.bucket_name == "" || var.ipset_iplist == [] ? 0 : 1
  activate    = true
  detector_id = aws_guardduty_detector.detector.id
  format      = var.ipset_format
  location    = "https://s3.amazonaws.com/${aws_s3_bucket.bucket[0].id}/${local.ipset_key}"
  name        = local.ipset_name
}

resource "aws_s3_bucket_object" "threatintelset" {
  count = var.bucket_name == "" || var.threatintelset_iplist == [] ? 0 : 1
  acl   = "public-read"
  content = templatefile("${path.module}/templates/threatintelset.txt.tpl",
  { threatintelset_iplist = var.threatintelset_iplist })
  bucket = aws_s3_bucket.bucket[0].id
  key    = local.threatintelset_key
}

resource "aws_guardduty_threatintelset" "threatintelset" {
  count       = var.bucket_name == "" || var.threatintelset_iplist == [] ? 0 : 1
  activate    = true
  detector_id = aws_guardduty_detector.detector.id
  format      = var.threatintelset_format
  location    = "https://s3.amazonaws.com/${aws_s3_bucket.bucket[0].id}/${local.threatintelset_key}"
  name        = local.threatintelset_name
}

resource "aws_guardduty_member" "members" {
  count       = length(data.aws_organizations_organization.org.non_master_accounts)
  account_id  = data.aws_organizations_organization.org.non_master_accounts[count.index]["id"]
  detector_id = aws_guardduty_detector.detector.id
  email       = data.aws_organizations_organization.org.non_master_accounts[count.index]["email"]
  invite      = true
}
