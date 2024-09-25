resource "aws_vpc" "Prod-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Prod-vpc"
  }
}

# Creating subnets
resource "aws_subnet" "FW-MGMT-security" {
  count      = length(var.subnets.subnet_cidr)
  vpc_id     = aws_vpc.Prod-vpc.id
  cidr_block = var.subnets.subnet_cidr[count.index]
  availability_zone = var.subnets.az[count.index]

  tags = {
    Name = var.subnets.subnetnames[count.index]
  }
}

resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.Prod-vpc.id

  tags = {
    Name = var.igw_name
  }
}

# Create EIP for Nat

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "Prod-NATGW"
  }
}
# Create Nat Gateway

resource "aws_nat_gateway" "Prod-nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.FW-MGMT-security[3].id

  tags = {
    Name = var.natgateway.name
  }
}

resource "aws_route_table_association" "association" {
  for_each       = local.subnet_to_route_table
  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
#edge_association = true  # Enabling edge association
}

resource "aws_route_table" "pvt-rt" {
  for_each = var.rt
  vpc_id   = aws_vpc.Prod-vpc.id
  dynamic "route" {
    for_each = each.value.routes
    content {
      cidr_block           = route.value.cidr
      gateway_id           = (route.value.gateway_id == "local" ? route.value.gateway_id: route.value.gateway_id == "" ? null: aws_internet_gateway.prod-igw.id)
      nat_gateway_id       = (route.value.nat_gateway_id == "nat" ? aws_nat_gateway.Prod-nat.id: null)
      #network_interface_id = (route.value.network_interface_id == "nic" ?  data.aws_network_interfaces.nic-tgw.ids[0]: null)
      #vpc_endpoint_id      = ( route.value.vpc_endpoint_id == "vpc_endpoint_out" ? module.sec-vpc.vpc_endpoint_1_out: route.value.vpc_endpoint_id == "vpc_endpoint_EW" ? module.sec-vpc.vpc_endpoint_2_EW: route.value.vpc_endpoint_id == "prod_vpc_endpoint" ? aws_vpc_endpoint.prod-gwlb_vpc_endpoint.id: null)
      #transit_gateway_id   = (route.value.transit_gateway_id == "tgw" ?  module.sec-vpc.transit_gateway_id: null)
      
                                                                  
    }
  } 
  tags = {
    Name = each.value.rt_name
  }
}