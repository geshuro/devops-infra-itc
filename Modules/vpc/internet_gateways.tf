resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(map("Name", format("igw-%s", aws_vpc.main.tags["Name"])), var.tags)

  lifecycle {
    prevent_destroy = false
    #TODO: IgnoreChanges
  }

}
