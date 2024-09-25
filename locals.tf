locals {
  # Define indices or identifiers for the 6 subnets you want to use
  subnet_indices = [0, 1, 2, 3]

  subnet_to_route_table = {
    for idx in local.subnet_indices : idx => {
      subnet_id      = aws_subnet.FW-MGMT-security[idx].id
      route_table_id = aws_route_table.pvt-rt["rt${idx + 1}"].id
    }
  }
}