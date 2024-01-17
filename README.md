# k8s-sunnyday
Training repository to setup an AWS EKS Kubernetes cluster from terraform


For being in high demand, this project demonstrates how to use terraform to deploy an EKS cluster to AWS.


Prerequisites:
1.  Configure AWS cli with `aws configure`; note: the default region is used in these scripts;
2.  Create a private repository in ECR with the name `k8simage`;
3.  Build & upload docker images with `/application/build_and_upload_all.sh` folder;


Deploying to AWS:
1.  cd into folder `iac/`
2.  run `terraform init`
3.  run `terraform plan`
4.  run `terraform apply`

