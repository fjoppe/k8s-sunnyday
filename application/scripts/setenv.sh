#!/bin/bash

export AWS_ACCOUNT=`aws sts get-caller-identity --query "Account" --output text`
export AWS_DEFAULT_REGION=`aws configure list | grep region | awk '{print $2}'`
export AWS_ECR_ENDPOINT=$AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com

