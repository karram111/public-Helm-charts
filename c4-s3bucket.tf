resource "aws_s3_bucket" "mybucketnew1" {
    bucket = "my1234my"
    //acl = "private"
    force_destroy = "true"

}

