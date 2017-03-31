#

# Security group resources

#

resource "aws_security_group" "mysql" {
  name_prefix = "${format("%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"))}_db_"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  tags {
    Project     = "${var.project}"
    Environment = "${var.environment}"
    created_by  = "terraform"
  }
}

#

# RDS resources

#

resource "aws_db_instance" "mysql" {
  allocated_storage          = "${var.allocated_storage}"
  engine                     = "mysql"
  engine_version             = "${var.engine_version}"
  identifier                 = "${var.project}-${var.environment}"
  instance_class             = "${var.instance_type}"
  storage_type               = "${var.storage_type}"
  name                       = "${var.database_name}"
  password                   = "${var.database_password}"
  username                   = "${var.database_username}"
  publicly_accessible        = "${var.publicly_accessible}"
  backup_retention_period    = "${var.backup_retention_period}"
  backup_window              = "${var.backup_window}"
  maintenance_window         = "${var.maintenance_window}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  multi_az                   = "${var.multi_availability_zone}"
  port                       = "3306"
  vpc_security_group_ids     = ["${aws_security_group.mysql.id}"]
  db_subnet_group_name       = "${aws_db_subnet_group.default.name}"
  parameter_group_name       = "${coalesce(var.existing_parameter_group_name, aws_db_parameter_group.default.name)}"
  storage_encrypted          = "${var.storage_encrypted}"

  depends_on = ["aws_db_parameter_group.default", "aws_db_subnet_group.default", "aws_security_group.mysql"]

  tags {
    Name        = "${format("%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"))}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    created_by  = "terraform"
  }
}

resource "aws_db_subnet_group" "default" {
  name        = "${format("%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"))}"
  description = "Subnets for the RDS instances"
  subnet_ids  = ["${var.subnet_ids}"]

  tags {
    Name        = "${format("%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"))}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    created_by  = "terraform"
  }
}

resource "aws_db_parameter_group" "default" {
  #count = "${signum(length(trimspace(var.parameter_group_name)))}"
  count = "${var.create_db_parameter_group}"

  name        = "${format("%s-%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"))}-${var.database_name}"
  description = "Parameter group for the RDS instances"
  family      = "${var.parameter_group_family}"

  parameter {
    name  = "log_bin_trust_function_creators"
    value = 1
  }

  tags {
    Project     = "${var.project}"
    Environment = "${var.environment}"
    created_by  = "terraform"
  }
}

#


# CloudWatch resources


#


/*resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "${format("%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"))}_alarmDatabaseServerCPUUtilization-${var.database_name}"
  alarm_description   = "Database server CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.mysql.id}"
  }

  alarm_actions = ["${split(",", var.alarm_actions)}"]
}

resource "aws_cloudwatch_metric_alarm" "disk_queue" {
  alarm_name          = "${format("%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"))}_alarmDatabaseServerDiskQueueDepth-${var.database_name}"
  alarm_description   = "Database server disk queue depth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.mysql.id}"
  }

  alarm_actions = ["${split(",", var.alarm_actions)}"]
}

resource "aws_cloudwatch_metric_alarm" "disk_free" {
  alarm_name          = "${format("%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"))}_alarmDatabaseServerFreeStorageSpace-${var.database_name}"
  alarm_description   = "Database server free storage space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"

  # 5GB in bytes
  threshold = "5000000000"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.mysql.id}"
  }

  alarm_actions = ["${split(",", var.alarm_actions)}"]
}

resource "aws_cloudwatch_metric_alarm" "memory_free" {
  alarm_name          = "${format("%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"))}_alarmDatabaseServerFreeableMemory-${var.database_name}"
  alarm_description   = "Database server freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"

  # 128MB in bytes
  threshold = "128000000"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.mysql.id}"
  }

  alarm_actions = ["${split(",", var.alarm_actions)}"]

  apply_immediately = "${var.apply_immediately}"
}
*/

