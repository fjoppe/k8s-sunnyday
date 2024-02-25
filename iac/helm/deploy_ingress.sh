#!/bin/bash

#   Configure kubectl for EKS
aws eks update-kubeconfig --region sa-east-1 --name "k8s-sunnyday"


#   source: https://amod-kadam.medium.com/setting-up-nginx-ingress-controller-with-eks-f27390bcf804

#   Add repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

#   Install ingress
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace


#   Add ingress rule, where we use ELB adress as host - note, we just asume there is only one ELB here!
ingresshost=`aws elb describe-load-balancers --query "LoadBalancerDescriptions[0].DNSName" --output "text"`
kubectl create ingress restapi --class=nginx --rule $ingresshost/*=restapi:8080


# uninstall ingress controller
# helm uninstall ingress-nginx -n ingress-nginx
