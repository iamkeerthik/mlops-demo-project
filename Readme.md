# Infrastructure & Deployment (GitOps)

This repository manages the core infrastructure and application delivery for the MLOps platform. It uses **Terraform** for Cloud Resources (AWS), **Helm** for cluster add-ons, and **Kubernetes manifests** for application-level deployments via GitOps.



## 📂 Repository Structure

```text
.
├── .github/workflows/         # CI/CD Pipelines
│   ├── terraform.yaml         # Infrapush (VPC, EKS, S3, ECR)
│   ├── helm.yaml              # Cluster Add-ons (ArgoCD, MLflow, Monitoring)
│   └── k8s_manifest.yaml      # App deployments (Model-1)
├── terraform/                 # Core Infrastructure (IaaS)
│   ├── 01-bootstrap/          # Base VPC & ECR setup
│   ├── eks/                   # Kubernetes Cluster configuration
│   ├── s3/                    # Storage for DVC/Model artifacts
│   └── env/                   # Environment-specific variables (.tfvars)
├── terraform-helm/            # Cluster Add-ons (PaaS)
│   └── addons/                # ArgoCD, LB Controller, MLflow, Prometheus
└── mlops/                     # Application Delivery
    └── apps/
        └── model-1/           # Kubernetes manifests for model serving
```

## 🏗️ Infrastructure Components
### 1. Core Infrastructure (Terraform)
The infrastructure is provisioned in a modular fashion:

* Bootstrap: Sets up the foundation (VPC, Networking, and ECR repositories).

* EKS: Provisions the Managed Kubernetes cluster, IAM roles, and Node groups.

* S3: Dedicated buckets for MLflow tracking and DVC data storage.

* Deployment Order:

 1. terraform/01-bootstrap

 2. terraform/s3

 3. terraform/eks

### 2. Cluster Add-ons (Terraform + Helm)
Once the EKS cluster is live, we deploy essential services using the Helm provider:

* ArgoCD: For GitOps-based CD.

* AWS Load Balancer Controller: To manage Ingress and ALBs.

* MLflow: For experiment tracking.

* Monitoring: Prometheus and Metrics Server for cluster health.


## 🚀 CI/CD & Deployment Pipelines

All infrastructure and application changes are managed through **Manual Triggers** (`workflow_dispatch`), allowing for granular control over environment selection and specific component updates.

| Pipeline | Trigger | Inputs / Options | Key Functionality |
| :--- | :--- | :--- | :--- |
| **Terraform CD** | 👋 Manual | `env`, `action`, `tf_component` | Provisions AWS IaaS (VPC, EKS, S3) & runs **Infracost** analysis. |
| **Helm Addons** | 👋 Manual | `env`, `action`, `addon` | Manages cluster services: ArgoCD, MLflow, KServe, Monitoring. |
| **K8s Deploy** | 👋 Manual | `env`, `action`, `path` | Applies/Destroys manifests (e.g., ArgoCD App-of-Apps config). |

---

### 🔍 Workflow Details

#### 💰 Terraform with Infracost Tracking
The `terraform.yaml` workflow includes a specialized loop to handle multi-component planning and cost estimation:
1. **Dynamic Execution:** Target specific components (e.g., `s3`, `eks`, or `all`).
2. **Cost Analysis:** - Converts Terraform plans to JSON.
   - Runs `infracost breakdown` for each component.
   - Appends a Markdown cost summary to the `plan.txt` log for review before application.

#### ☸️ Helm Addons Management
The `helm.yaml` workflow allows you to maintain the cluster state without redeploying the core infrastructure.
* **Targeting:** You can update individual addons (like `mlflow`) or sync the entire suite (`all`).
* **Provider:** Uses Terraform's Helm provider for idempotent state management.

#### 📄 Kubernetes Manifests
The `k8s_manifest.yaml` workflow provides a direct interface to the EKS cluster.
* **Flexibility:** Can point to a single file (like `dev-argo-app.yaml`) or a whole folder of manifests.
* **Default Path:** Points to the ArgoCD application values by default to facilitate GitOps synchronization.

---