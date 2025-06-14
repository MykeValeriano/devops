## Helm Mastery Guide with Exercises

---

### Phase 1: Helm Basics

#### Topic 1: Install Helm & Run First Chart

**Objective:** Install Helm and run a basic chart.

**Instructions:**

1. Start Minikube:
   ```bash
   minikube start
   ```
2. Install Helm (if not already installed):
   ```bash
   curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
   ```
3. Add Bitnami Helm repository:
   ```bash
   helm repo add bitnami https://charts.bitnami.com/bitnami
   helm repo update
   ```
4. Install Nginx chart:
   ```bash
   helm install my-nginx bitnami/nginx
   ```
5. Access the app:
   ```bash
   minikube service my-nginx
   ```

---

#### Topic 2: Chart Structure

**Objective:** Understand and explore chart structure.

**Instructions:**

1. Create a chart:
   ```bash
   helm create mychart
   ```
2. Explore the files:
   - `Chart.yaml`: Chart metadata
   - `values.yaml`: Default values
   - `templates/`: Contains templated Kubernetes manifests
3. Run it:
   ```bash
   helm install mychart ./mychart
   ```
4. View generated manifests:
   ```bash
   helm template mychart ./mychart
   ```

---

### Phase 2: Intermediate Helm Skills

#### Topic 3: Templates & Values

**Instructions:**

1. Edit `values.yaml`:
   ```yaml
   replicaCount: 3
   image:
     repository: nginx
     tag: 1.21.6
     pullPolicy: IfNotPresent
   ```
2. Edit `deployment.yaml`:
   ```yaml
   replicas: {{ .Values.replicaCount }}
   image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
   ```
3. Upgrade chart:
   ```bash
   helm upgrade mychart ./mychart
   ```

---

#### Topic 4: Conditionals and Loops

**Instructions:**

1. In `values.yaml`, add:
   ```yaml
   config:
     enabled: true
     data:
       LOG_LEVEL: debug
       FEATURE_FLAG: true
   ```
2. In `templates/configmap.yaml`:
   ```yaml
   {{- if .Values.config.enabled }}
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: {{ include "mychart.fullname" . }}
   data:
     {{- range $key, $value := .Values.config.data }}
     {{ $key }}: "{{ $value }}"
     {{- end }}
   {{- end }}
   ```

---

#### Topic 5: Dependencies

**Instructions:**

1. Add dependency in `Chart.yaml`:
   ```yaml
   dependencies:
     - name: redis
       version: "17.0.0"
       repository: "https://charts.bitnami.com/bitnami"
   ```
2. Run:
   ```bash
   helm dependency update
   helm install mychart ./mychart
   ```

---

#### Topic 6: Helm Hooks

**Instructions:**

1. Create a hook file in `templates/job.yaml`:
   ```yaml
   apiVersion: batch/v1
   kind: Job
   metadata:
     name: {{ include "mychart.fullname" . }}-init-job
     annotations:
       "helm.sh/hook": pre-install
   spec:
     template:
       spec:
         containers:
           - name: init
             image: busybox
             command: ['sh', '-c', 'echo Initializing...']
         restartPolicy: Never
   ```

---

### Phase 3: Advanced Helm Topics

#### Topic 7: Lifecycle - Upgrade and Rollback

**Instructions:**

1. Install initial release:
   ```bash
   helm install mychart ./mychart
   ```
2. Change `values.yaml` (e.g., update image tag), then run:
   ```bash
   helm upgrade mychart ./mychart
   ```
3. Roll back:
   ```bash
   helm rollback mychart 1
   ```

---

#### Topic 8: Helm Testing

**Instructions:**

1. Create `templates/tests/test-connection.yaml`:
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: "{{ include "mychart.fullname" . }}-test-connection"
     annotations:
       "helm.sh/hook": test
   spec:
     containers:
       - name: wget
         image: busybox
         command: ['wget', 'http://my-nginx']
     restartPolicy: Never
   ```
2. Run tests:
   ```bash
   helm test mychart
   ```

---

#### Topic 9: Lint Charts

**Instructions:**

```bash
helm lint ./mychart
```

---

#### Topic 10: Chart Repositories

**Instructions:**

1. Package chart:
   ```bash
   helm package mychart
   ```
2. Create index:
   ```bash
   helm repo index .
   python3 -m http.server 8080
   ```
3. Add custom repo:
   ```bash
   helm repo add myrepo http://localhost:8080
   helm install mychart myrepo/mychart
   ```

---

#### Topic 11: Security & Secrets

**Instructions:**

1. Encode a secret in `values.yaml`:
   ```yaml
   secret: cGFzc3dvcmQ=
   ```
2. Use in template:
   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: {{ include "mychart.fullname" . }}-secret
   type: Opaque
   data:
     password: {{ .Values.secret }}
   ```

---

#### Topic 12: CI/CD with Helm

**Instructions:**

1. Example GitHub Actions Workflow (`.github/workflows/deploy.yaml`):
   ```yaml
   name: Helm Deploy
   on: [push]
   jobs:
     deploy:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v2
         - name: Setup Helm
           uses: azure/setup-helm@v3
         - name: Lint Chart
           run: helm lint ./mychart
         - name: Deploy to Cluster
           run: helm upgrade --install mychart ./mychart --kubeconfig ${{ secrets.KUBECONFIG }}
   ```

---

This full guide and hands-on workflow is designed to give you mastery over Helm in Kubernetes environments. Let me know if you want to dive deeper into any of these topics!

