resource "aws_iam_policy" "ec2_policy" {
  name = "ec2policy"
  path = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:*",
            "s3-object-lambda:*"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:Describe*",
            "ssm:Get*",
            "ssm:List*"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}


resource "aws_iam_role" "ec2_s3_access" {
  name = "EC2AccessRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_full_access" {
  name = "EC2FullAccessPolicy"
  role = aws_iam_role.ec2_s3_access.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "s3:*",
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = ["ssm:Describe*",
          "ssm:Get*",
        "ssm:List*"]
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  policy_arn = aws_iam_policy.ec2_policy.arn
  role       = aws_iam_role.ec2_s3_access.name
}

resource "aws_iam_instance_profile" "ec2_profile1" {
  name = "testprofile1"
  role = aws_iam_role.ec2_s3_access.name
}