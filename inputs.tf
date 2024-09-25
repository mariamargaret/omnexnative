variable "vpc_cidr" {
  type = string
}

variable "subnets" {
  type = object({
    subnet_cidr = list(string)
    subnetnames = list(string)
    az = list(string)
  })
}
variable "igw_name" {
  type = string
}


# Variable for AMI ID
variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance"
  type        = string
  default     = "ami-0467f98eacda991cc" # Replace with your AMI ID
}

# Variable for key pair name
variable "key_name" {
  description = "The name of the key pair to use for SSH access to the instance"
  type        = string
  default     = "newkey" # Replace with your key pair name
}


variable "natgateway" {
  type = object({
    name = string
  })
}

variable "rt" {
  type = map(object({
    rt_name = string
    routes = list(object({
      cidr                 = string
      #vpc_endpoint_id      = string
     # network_interface_id = string
      gateway_id           = string
      nat_gateway_id       = string
     # transit_gateway_id   = string
    }))

  }))

}
