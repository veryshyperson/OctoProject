# This is the Real Deal

<img width="1000" alt="Image" src="https://github.com/user-attachments/assets/24fadd82-ce9d-41e5-b38b-5fe5202ce199" />

Welcome to the ultimate Terraform module. Everything you need to provision a production-ready Kubernetes cluster with AWS is here. From networking to compute, security to automation, this setup ensures a fully functional EKS environment with ArgoCD, NGINX, and an apple-basket application – all deployed with a single `terraform apply`.

---

## Terraform Files Structure

```
vpc.tf				acm.tf
eks.tf              providers.tf
blueprints.tf       applebasket.tf
```

---

## VPC

- The VPC includes **all availability zones per region** except **AZ-E**, as it's not supported for EKS.
- **Public subnets** are routed through an **Internet Gateway** for external access.
- **Private subnets** are routed through a **NAT Gateway**, specifically designed for **Node Groups**.
- **Tagging for AWS Load Balancer:**
  - Public-facing load balancers use the `"elb"` tag.
  - Internal load balancers use the `"internal-elb"` tag.

---

## EKS

- The cluster uses **AmazonEBSCSIDriverPolicy** (`arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy`) to allow persistent storage for stateful workloads.
- Since we **don't** use **MongoDB RDS**, the application pods remain **stateful** by mounting their **PVCs** onto dynamically created EBS volumes.
- **IAM Role for Service Accounts (IRSA) is NOT used** – instead, cluster changes are managed through an **OpenID Connect IAM Role**.

---

## ACM & Blueprints

### ACM (AWS Certificate Manager)

- Ensures the domain is **secured** with SSL/TLS.

### Blueprints

- Deploys core infrastructure components:
  1. **ArgoCD** - GitOps for managing Kubernetes applications.
  2. **NGINX Ingress Controller** & `kubernetes_ingress_v1` for AWS ALB integration.
  3. **EKS Addons**, including:
     - AWS Load Balancer Controller
     - Amazon CSI Driver for dynamic storage provisioning
  4. **kubectl resource** applies an **ArgoCD application**, deploying the **apple-basket** app into the cluster.

> Everything builds **from scratch** to perfection with a **single** `terraform apply`.

---

<img width="1000" alt="Image" src="https://github.com/user-attachments/assets/42b35238-d312-49e2-a68a-95e0a26be80f" />

## Kubernetes Manifests

The following manifests define the Kubernetes resources required for the application:

- **db-stateful**: Defines a StatefulSet for the database, ensuring persistence.
- **app-deployment**: Manages the deployment of the apple-basket application.
- **app-service**: Exposes the application internally or externally.
- **ingress**: Manages external access to the application via ALB.
- **db-service**: Provides a stable network endpoint for the database.
- **PVC (Persistent Volume Claim)**: Initializes an **EBS-backed gp2 Persistent Volume** using the defined IAM permissions.

---

## Make it Happen!

Navigate to the `3EKS` directory and run:

```bash
terraform init
terraform apply
```

Sit back and watch your entire infrastructure **provisioned and deployed** in minutes!

