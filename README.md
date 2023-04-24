# WORTH-ASSESSMENT
 
## Prerequisites

* AWS account
* Terraform installed on your local machine
* Installing tflint to enforce best practice

[ FINDING POSSIBLE ERRORS, WARN ABOUT DEPRECATED SYNTAX UNUSED DECLARATION ]

# Overview

This is a Terraform configuration file that provisions resources on AWS for a hypothetical website. The script creates an S3 bucket for storing the website files and configures it for hosting static content. It also creates IAM policies and users to allow different groups of users to access and modify the website files in different ways.

# AWS Provider

I have choosen AWS as a cloud provider in the  AWS provider block that Terraform uses to authenticate to the AWS API and specify the region in which to create the resources.

# S3 Bucket for Website

Next, the script creates an S3 bucket for storing the website files. The aws_s3_bucket resource block creates the bucket with a given name and sets the bucket's Access Control List (ACL) to public-read. The public-read ACL allows anyone to read the objects in the bucket without the need for authentication.

# Website Hosting Configuration
The aws_s3_bucket_website resource block enables website hosting for the S3 bucket created above. It specifies the default index document and error document to use when a user requests the root URL of the bucket and encounters an error, respectively.


# IAM Policies and Users
The script creates three IAM policies to allow different groups of users to access and modify the website files in different ways. The policies are defined using JSON-encoded strings that specify a set of statements, each containing an effect (either "Allow" or "Deny"), a list of actions, and a list of resources.

# Marketing Policy

The aws_iam_policy.marketing_policy resource block creates an IAM policy that allows users to read and write to the entire S3 bucket, but only if the objects are marked with a public-read ACL.

# Content Editor Policy
The aws_iam_policy.content_editor_policy resource block creates an IAM policy that allows users to read and write to the entire S3 bucket.


------------------------------------------------------------------
# NOTE 
You should also configure any required secrets, like AWS access key and secret key, in your repository settings and use them in your Terraform scripts.
