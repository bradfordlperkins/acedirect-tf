resource "aws_security_group" "fcc-acedirect-prod-web-sg" {
  name = "fcc-acedirect-prod-web-sg"
  description = "Allow web server traffic"
  vpc_id = aws_vpc.fcc_acedirect_prod_vpc.id
  tags = {
    Name = "fcc-acedirect-prod-web-sg"
  }
}

resource "aws_security_group" "fcc-acedirect-prod-swan-sg" {
  name = "fcc-acedirect-prod-swan-sg"
  description = "Allow web server traffic"
  vpc_id = aws_vpc.fcc_acedirect_prod_vpc.id
  tags = {
    Name = "fcc-acedirect-prod-swan-sg"
  }

  #Ingress
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "DNS"
  }

  ingress {
      from_port   = 4500
      to_port     = 4500
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 500
      to_port     = 500
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 50
      to_port     = 51
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Strongswan"
  }

  ingress {
      from_port   = 50
      to_port     = 51
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Strongswan"
  }

  #Egress
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "fcc-acedirect-prod-rdp-sg" {
  name = "fcc-acedirect-prod-rdp-sg"
  description = "Allow RDP to Windows server"
  vpc_id = aws_vpc.fcc_acedirect_prod_vpc.id
  tags = {
    Name = "fcc-acedirect-prod-rdp-sg"
  }

  #Ingress
  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["10.116.92.0/22"]
  }

  ingress {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = ["71.178.44.250/32"]
  }

  #Egress
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "fcc-acedirect-prod-providers-sg" {
  name = "fcc-acedirect-prod-providers-sg"
  description = "Allow traffic from specific phone providers in"
  vpc_id = aws_vpc.fcc_acedirect_prod_vpc.id
  tags = {
    Name = "fcc-acedirect-prod-providers-sg"
  }

  #Ingress
  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "50"
      cidr_blocks = ["209.18.122.132/32"]
      description = "iConectiv"
  }

  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "51"
      cidr_blocks = ["209.18.122.132/32"]
      description = "iConectiv"
  }

  ingress {
      from_port   = 500
      to_port     = 500
      protocol    = "udp"
      cidr_blocks = ["209.18.122.132/32"]
      description = "iConectiv"
  }

  ingress {
      from_port   = 4500
      to_port     = 4500
      protocol    = "udp"
      cidr_blocks = ["209.18.122.132/32"]
      description = "iConectiv"
  }

  #Egress
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "fcc-acedirect-prod-rds-sg" {
  name = "fcc-acedirect-prod-rds-sg"
  description = "Allow RDS server traffic"
  vpc_id = aws_vpc.fcc_acedirect_prod_vpc.id
  tags = {
    Name = "fcc-acedirect-prod-rds-sg"
  }
}

resource "aws_security_group_rule" "ingress_provider_1" {
  count = "${length(var.ingress_provider_cidr)}"

  type        = "ingress"
  protocol    = "-1"
  cidr_blocks = ["${element(var.ingress_provider_cidr, count.index)}"]
  from_port   = 0
  to_port     = 0

  security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}


resource "aws_security_group_rule" "ingress_web_1" {
  count = "${length(var.ingress_web_ports_1)}"

  type        = "ingress"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = "${element(var.ingress_web_ports_1, count.index)}"
  to_port     = "${element(var.ingress_web_ports_1, count.index)}"

  security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "ingress_web_2" {
  count = "${length(var.ingress_web_ports_2)}"

  type        = "ingress"
  protocol    = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = "${element(var.ingress_web_ports_2, count.index)}"
  to_port     = "${element(var.ingress_web_ports_2, count.index)}"

  security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "ingress_web_3" {
  count = "${length(var.protocols)}"

  type        = "ingress"
  protocol    = "${element(var.protocols, count.index)}"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 10000
  to_port     = 20000

  security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "ingress_web_4" {
  type        = "ingress"
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = -1
  to_port     = -1

  security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "ingress_web_5" {
  type        = "ingress"
  protocol    = "-1"
  cidr_blocks = ["156.154.0.0/16"]
  from_port   = 0
  to_port     = 0

  security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "egress_web_1" {
  count = "${length(var.egress_web_ports_1)}"

  type        = "egress"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = "${element(var.egress_web_ports_1, count.index)}"
  to_port     = "${element(var.egress_web_ports_1, count.index)}"

  security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "egress_web_2" {
  count = "${length(var.egress_web_ports_2)}"

  type        = "egress"
  protocol    = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = "${element(var.egress_web_ports_2, count.index)}"
  to_port     = "${element(var.egress_web_ports_2, count.index)}"

  security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "egress_web_3" {
  count = "${length(var.protocols)}"

  type        = "egress"
  protocol    = "${element(var.protocols, count.index)}"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 10000
  to_port     = 20000

  security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "egress_web_4" {
  count = "${length(var.protocols)}"

  type        = "egress"
  protocol    = "${element(var.protocols, count.index)}"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 7000
  to_port     = 65535

  security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "egress_web_5" {
  type        = "egress"
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = -1
  to_port     = -1

  security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "egress_web_6" {
  type        = "egress"
  protocol    = "-1"
  cidr_blocks = ["156.154.0.0/16"]
  from_port   = 0
  to_port     = 0

  security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "igress_rds_1" {
  type        = "ingress"
  protocol    = "tcp"
  cidr_blocks = ["73.14.137.136/32"]
  from_port   = 3306
  to_port     = 3306

  security_group_id = "${aws_security_group.fcc-acedirect-prod-rds-sg.id}"
}

resource "aws_security_group_rule" "egress_rds_1" {
  type        = "egress"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 0
  to_port     = 0

  security_group_id = "${aws_security_group.fcc-acedirect-prod-rds-sg.id}"
}

resource "aws_security_group_rule" "fcc-acedirect-prod-rds-sg_extra_tcp_rule" {
    security_group_id = "${aws_security_group.fcc-acedirect-prod-rds-sg.id}"
    from_port                = 0
    to_port                  = 65535
    protocol                 = "tcp"
    type                     = "ingress"
    source_security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "fcc-acedirect-prod-rds-sg_extra_udp_rule" {
    security_group_id = "${aws_security_group.fcc-acedirect-prod-rds-sg.id}"
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    type = "ingress"
    source_security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
}

resource "aws_security_group_rule" "fcc-acedirect-prod-web-sg_extra_rule" {
    security_group_id = "${aws_security_group.fcc-acedirect-prod-web-sg.id}"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    type = "egress"
    source_security_group_id = "${aws_security_group.fcc-acedirect-prod-rds-sg.id}"
}