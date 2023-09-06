
resource "aws_vpc" "dd_vpc"{ 
	cidr_block = "10.0.0.0/16"
	instance_tenancy = "default"
	tags = {
		Name = "vpc_dd"
	       }	
	} 
resource "aws_subnet" "dd_subnet"{
	vpc_id = aws_vpc.dd_vpc.id 
	cidr_block = "10.0.1.0/24"
	tags = {
		Name = "subnet_dd"
	       }
	map_public_ip_on_launch = true
	}
resource "aws_internet_gateway" "dd_igw"{
	vpc_id = aws_vpc.dd_vpc.id 
	tags = {
		Name = "igw_dd"
	       }
	}
resource "aws_route_table" "dd_rt" {
	vpc_id = aws_vpc.dd_vpc.id
	route {
		cidr_block = "0.0.0.0/0"
    		gateway_id = aws_internet_gateway.dd_igw.id
  	      }
  	tags = {
    		Name = "rt_dd"
  	       }
	}
resource "aws_route_table_association" "dd_rta" {
  subnet_id      = aws_subnet.dd_subnet.id
  route_table_id = aws_route_table.dd_rt.id
}

resource "aws_security_group" "dd_sg" {
  description = "security group"
  vpc_id = aws_vpc.dd_vpc.id 
  tags = {
	Name = "sg_dd"
  }

   ingress {
	to_port = 0
	from_port = 0 # meaning to apply for all the ports
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
	to_port = 0
	from_port = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
 }


resource "aws_instance" "wordpress_vm" {
  ami           = "ami-04a5a6be1fa530f1c" 
  instance_type = "t3.micro"           
  subnet_id     = aws_subnet.dd_subnet.id      
  key_name      = "Terraform_kp"  
  vpc_security_group_ids = [aws_security_group.dd_sg.id]
  # Add security group and other necessary configurations
  tags = {
 		Name = "Wordpress" 
 	    }
}
