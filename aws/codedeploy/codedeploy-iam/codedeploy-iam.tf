resource "aws_iam_role" "codedeploy-role" {
  name = "${var.project}_${var.environment}_CodeDeployDeployerRole"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS":"arn:aws:iam::${var.deployer_account_id}:root" 
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "codedeploy-role-AWSCodeDeployDeployerAccess-attach" {
  name       = "${aws_iam_role.codedeploy-role.name}_managed-policies"
  roles      = ["${aws_iam_role.codedeploy-role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployDeployerAccess"
}

# Jenkins specific IAM Role Policy.  This will only get created if a jenkins IAM role is passed in.
resource "aws_iam_role_policy" "jenkins-assumerole-codedeploy-role_policy" {
  # Only having to have count variable until the following bug is fixed.  https://git.io/voujC
  # count = "${signum(length(trimspace(var.jenkins_iam_role_id)))}"
  count = "${var.jenkins_iam_role_count}"

  name = "${var.project}_${var.environment}_STSAssumeRole_JenkinsCodeDeployRole"
  role = "${var.jenkins_iam_role_id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_iam_role.codedeploy-role.arn}",
        "${join("\",\n        \"", split(",", var.external_codedeploy_deployer_role_arns))}"
      ]          
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3-all-codedeploy-role-policy" {
  name = "${var.project}_${var.environment}_S3All_CodeDeploy"
  role = "${aws_iam_role.codedeploy-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${var.codedeploy_s3_bucket_arn}",
        "${var.codedeploy_s3_bucket_arn}/*"
      ]
    }, {
      "Effect" : "Allow",
      "Action" : [ "s3:GetBucketLocation", "s3:ListAllMyBuckets" ],
      "Resource" : "*"
    }
  ]
}
EOF
}

# IAM Role which gives code deploy the ability to discover instances
resource "aws_iam_role" "codedeploy-service-role" {
  name = "${var.project}_${var.environment}_CodeDeployServiceRole"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Principal": {
        "Service":"codedeploy.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codedeploy-role-policy" {
  name = "${var.project}_${var.environment}_CodeDeployRole"
  role = "${aws_iam_role.codedeploy-service-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": [ "*" ]
    }, {
      "Effect" : "Allow",
      "Action" : [ 
        "autoscaling:CompleteLifecycleAction", 
        "autoscaling:DeleteLifecycleHook", 
        "autoscaling:DescribeLifecycleHooks", 
        "autoscaling:DescribeAutoScalingGroups", 
        "autoscaling:PutLifecycleHook", 
        "autoscaling:RecordLifecycleActionHeartbeat" ],
      "Resource" : "*"
    }, {
      "Effect": "Allow",
      "Resource": [ "*" ],
      "Action" : [ 
        "Tag:getResources", 
        "Tag:getTags", 
        "Tag:getTagsForResource", 
        "Tag:getTagsForResourceList" ]
    }
  ]
}
EOF
}
