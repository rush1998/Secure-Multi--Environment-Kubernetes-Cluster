## Step 1: Infrastructure Setup

### Objective

Provision an Amazon EKS cluster using Terraform, with separate VPCs for development, testing, and production environments.

### Directory Structure

Created three directories, each containing its own VPC configuration:

* `dev/`
* `test/`
* `prod/`

Each directory has a dedicated VPC to isolate the environments.

### Dev Environment Setup

#### 1. EKS Module Configuration

In the `dev/` directory, I configured the EKS module as follows:

```
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.1.0"

  name               = local.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  tags = {
    cluster = "demo"
  }

  eks_managed_node_groups = {
    node_group = {
      instance_types = ["t3.medium"] # moved here
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }
}

```

#### 2. Terraform Commands Executed

* **Initialize Terraform** : `terraform init`
* **Validate Configuration** : `terraform validate`
* **Plan Execution** : `terraform plan`
* **Apply Changes** : `terraform apply -auto-approve`

![1755565044278](image/README/1755565044278.png)

![1755565051489](image/README/1755565051489.png)

The cluster is created

![1755565367883](image/README/1755565367883.png)

This is the node group

![1755674513677](image/README/1755674513677.png)

## Step 2: Security Implementation

Configure RBAC

I have configures RBAC policy for a new user who wants to access the cluser, grant read-only access to specific resources across all namespaces in the cluster

```
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: viewer
rules:
  - apiGroups: ["*"]
    resources: ["deployments", "configmaps", "pods", "secrets", "services"]
    verbs: ["get", "list", "watch"]
```

For this I have created a user name **developer** which has limited access

![1755675657129](image/README/1755675657129.png)

Now when I do aws config using the developer user i cannoot access my cluster node name

![1755676338413](image/README/1755676338413.png)

Where as my dev user has all accees

![1755676456815](image/README/1755676456815.png)

Now Creating network policies

Create the Frontend and Backend Deployments

Create the Network Policy for Backend

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-network-policy
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: frontend
```

Verify the Network Policy

![1755772540840](image/README/1755772540840.png)

After applyying the network policy it will fail to connect

![1755772926008](image/README/1755772926008.png)

## Step 3: Monitoring & Logging

Implementing Prometheus and Grafana for node.js application

![1755892173819](image/README/1755892173819.png)

![1755892187267](image/README/1755892187267.png)

Running promethous using helm

![1755892209540](image/README/1755892209540.png)

Running Graphana using helm

![1755892249794](image/README/1755892249794.png)

This query **checks whether the Kubernetes service `node-k8s-demo-service` exists** (and returns `1` if it does).

![1755892504048](image/README/1755892504048.png)
