resource "aws_launch_template" "this" {
  name_prefix   = "lt-${var.name_prefix}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = var.user_data

  vpc_security_group_ids = [var.app_sg_id]

  monitoring {
    enabled = false
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = "ec2-${var.name_prefix}-web"
      Role = "web"
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(var.tags, {
      Name = "ec2-${var.name_prefix}-volume"
    })
  }

  tags = merge(var.tags, {
    Name = "lt-${var.name_prefix}"
  })
}

resource "aws_autoscaling_group" "this" {
  name                      = "asg-${var.name_prefix}"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = "ELB"
  health_check_grace_period = 120
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-${var.name_prefix}"
    propagate_at_launch = false
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
