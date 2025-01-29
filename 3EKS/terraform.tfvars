  region = "us-east-1"

  stamp = "octopus"
  domain = "bokertovmatoki.online"

  vpc_cidr = "10.0.0.0/16"

  ec2_type = "t2-medium"
  min_size = 1
  max_size = 4
  desired_size = 2

  db_engine = "mysql"
  db_name= "gitops"
  db_type = "db.t3.micro"
  db_engine_version = "8.0"


  _LocalAdmin = "arn:aws:iam::058264364931:role/_LocalAdmin"