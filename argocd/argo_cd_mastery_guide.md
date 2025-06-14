# Argo CD Mastery Guide

## Module 1: Introduction & Setup (Beginner)

### 🎯 Objectives

- Understand what Argo CD is and how it fits into GitOps
- Install and configure Argo CD on Kubernetes
- Explore the UI, CLI, and API
- Deploy your first application using Argo CD

### 📘 Topics Covered

- What is Argo CD?
- GitOps principles
- Argo CD architecture (overview)
- Argo CD components (API server, repo server, application controller, Dex)
- Installation methods (kubectl, Helm, Kustomize)
- Accessing the Argo CD dashboard
- Login and authentication
- CLI setup (`argocd login`, `argocd context`)

### 🧪 Hands-on Exercises

#### 🚀 Install Argo CD (kubectl)

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

- ✅ **Test:** `kubectl get pods -n argocd`
- 🔍 **Explanation:** Downloads and installs Argo CD in the `argocd` namespace

#### 🔐 Access UI & Login

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
argocd login localhost:8080 --username admin --password <initial-password>
```

- ✅ **Test:** Login from CLI and UI

#### 🎯 First App (Git + YAML)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/argoproj/argocd-example-apps.git
    targetRevision: HEAD
    path: guestbook
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

- ✅ **Test:** `argocd app sync guestbook`

---

## Module 2: App Management & Sync (Intermediate)

### 🎯 Objectives

- Learn how Argo CD syncs apps from Git
- Understand declarative vs imperative deployment
- Learn app status, lifecycle, health

### 📘 Topics Covered

- App lifecycle
- Sync waves, sync options
- Self-healing and pruning
- App status and health checks
- Imperative commands (`argocd app sync`, `argocd app delete`, `argocd app wait`)
- Declarative application definitions

### 🧪 Hands-on Exercises

#### 🔄 Syncing an Application

```bash
argocd app sync guestbook
```

- ✅ **Explanation:** Syncs app to match Git state

#### 🧪 Imperative Create

```bash
argocd app create nginx \
--repo https://github.com/argoproj/argocd-example-apps.git \
--path nginx \
--dest-server https://kubernetes.default.svc \
--dest-namespace default
```

#### 🧾 Declarative Application YAML

```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

- ✅ **Test:** Change Git file and observe auto-sync

---

## Module 3: Projects, RBAC, SSO, UI/CLI (Intermediate)

### 🎯 Objectives

- Manage Argo CD at scale
- Enforce app boundaries using AppProjects
- Secure access with RBAC and SSO

### 📘 Topics Covered

- AppProjects (restrictions by repo, namespace, cluster)
- RBAC policies via `argocd-rbac-cm`
- SSO via Dex (GitHub, LDAP, SAML)
- Config Maps: `argocd-cm`, `argocd-rbac-cm`
- CLI deep dive: all major commands

### 🧪 Hands-on Exercises

#### 📂 AppProject YAML

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: dev-team
spec:
  destinations:
    - namespace: dev
      server: https://kubernetes.default.svc
  sourceRepos:
    - https://github.com/org/dev-repo
```

#### 🔐 RBAC Role Example

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
  labels:
    app.kubernetes.io/name: argocd-rbac-cm
  data:
    policy.csv: |
      p, role:dev, applications, get, dev/*, allow
      g, alice, role:dev
```

#### 🔐 SSO Setup Sample

(Instructions to integrate with GitHub SSO using Dex config)

---

## Module 4: Advanced Features (Advanced)

### 🎯 Objectives

- Automate advanced deployment strategies
- Scale applications with generators and hooks

### 📘 Topics Covered

- ApplicationSets (List, Matrix, Git, Cluster generators)
- Resource hooks (pre-sync, post-sync)
- Custom health checks
- Notifications controller
- Image Updater

### 🧪 Hands-on Exercises

#### 🧩 ApplicationSet (List Generator)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: apps-list
spec:
  generators:
    - list:
        elements:
          - cluster: https://dev.k8s.cluster
            app: frontend
          - cluster: https://prod.k8s.cluster
            app: backend
  template:
    metadata:
      name: '{{app}}'
    spec:
      destination:
        server: '{{cluster}}'
        namespace: '{{app}}'
```

#### 🔁 Sync Hooks Example

```yaml
annotations:
  argocd.argoproj.io/hook: PreSync
```

#### 🔔 Notifications Example

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
```

#### 🧼 Custom Health Check

```yaml
health.lua:
  apiVersion: apps/v1
  kind: Deployment
  script: |
    if obj.status.availableReplicas == obj.status.replicas then
      return "Healthy"
    end
```

---

## Module 5: Expert Use Cases & Capstone Project (Expert)

### 🎯 Objectives

- Simulate enterprise-grade GitOps workflows
- Implement access control for multiple teams
- Deploy across dev/staging/prod clusters
- Enable disaster recovery
- Build a GitOps CI/CD pipeline with Argo CD

### 🛡️ Multi-Team RBAC Access Control

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
  labels:
    app.kubernetes.io/name: argocd-rbac-cm
  data:
    policy.csv: |
      p, role:devs, applications, get, dev/*, allow
      p, role:ops, applications, sync, staging/*, allow
      g, alice, role:devs
      g, bob, role:ops
```

### 🌐 Multi-Cluster Deployment Example

```bash
argocd cluster add dev-context
argocd cluster add staging-context
argocd cluster add prod-context
```

### 🔁 Rollbacks & Drift Detection

```bash
argocd app diff my-app
argocd app rollback my-app 1
```

### 💾 Disaster Recovery

```bash
kubectl get configmaps,secrets -n argocd -o yaml > argocd-backup.yaml
kubectl apply -f argocd-backup.yaml
```

### 🏗️ Capstone: GitOps Pipeline with Argo CD + Helm + Kustomize + AppSets

**Git Structure:**

```
gitops/
├── apps/
│   └── frontend/backend
│       ├── base/
│       └── overlays/dev/staging/prod
├── clusters/
├── applicationsets/
```

**ApplicationSet:**

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: microservices-env
spec:
  generators:
    - list:
        elements:
          - env: dev
            cluster: https://dev.k8s.cluster
  template:
    metadata:
      name: '{{env}}-frontend'
    spec:
      destination:
        server: '{{cluster}}'
```

**CI Integration (GitHub Actions)**

```yaml
name: CI
on:
  push:
    paths:
      - apps/**
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: git commit -am "Update"
```

---

## Module 6: Testing, Validation & Troubleshooting

### 🎯 Objectives

- Validate YAMLs, App syncs, CLI workflows
- Understand logs and drift

### 🧪 Common Validation Commands

```bash
argocd app wait my-app
kubectl describe app <name>
kubectl get events
```

### 🧰 Debugging Examples

- 🔍 Wrong repo URL → error in `argocd app events`
- 🔧 Missing RBAC → UI login blocked

### ✅ Success Criteria

- App syncs
- No diff or drift
- Configs validated

---

## Module 7: Capstone Expansion & GitOps Best Practices

### 🎯 Objectives

- Production-ready CI/CD
- Best practices in structure, collaboration, branching

### 🧱 Git Structure Expanded

```
gitops/
├── apps/
│   └── <service>/base, overlays
├── environments/
├── policies/
├── dashboards/
```

### 📊 Monitoring Integrations

- Prometheus + Grafana dashboards for sync metrics
- Argo CD metrics endpoint exposed via serviceMonitor

### 🔁 Rollbacks by Git SHA

```bash
argocd app history my-app
argocd app rollback my-app <id>
```

### 🧪 Exercise: Simulate Disaster Recovery

1. Delete Argo CD namespace
2. Restore from backup YAML
3. Sync all apps from CLI

### 📌 Summary

- Built enterprise GitOps
- SSO, RBAC, HA, disaster recovery
- Scalable, observable workflows

🎓 You are now a full **Argo CD Master**!

