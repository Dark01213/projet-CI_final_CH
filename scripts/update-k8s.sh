#!/bin/bash

echo "Fixing k3s permissions and updating deployments..."
sudo systemctl stop k3s || true
sudo k3s server --write-kubeconfig-mode 644 &
sleep 15
sudo k3s kubectl cluster-info || { echo "k3s cluster not accessible"; exit 1; }

echo "Applying Kubernetes manifests..."

# Apply ConfigMap
cat <<EOF | sudo k3s kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: default
  labels:
    app: task-app
data:
  environment: "production"
  debug: "False"
  api_url: "http://backend-service:5000"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
  namespace: default
  labels:
    app: task-app
    component: frontend
data:
  default.conf: |
    server {
        listen 80;
        server_name localhost;

        root /usr/share/nginx/html;
        index index.html index.htm;

        location / {
            try_files \$uri \$uri/ /index.html;
        }

        location /api {
            proxy_pass http://backend-service:5000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host \$host;
            proxy_cache_bypass \$http_upgrade;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }

        location /health {
            proxy_pass http://backend-service:5000;
            proxy_http_version 1.1;
        }

        error_page 404 /index.html;
    }
EOF

# Apply Backend Deployment and Service
cat <<EOF | sudo k3s kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-deployment
  namespace: default
  labels:
    app: task-app
    component: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: task-app
      component: backend
  template:
    metadata:
      labels:
        app: task-app
        component: backend
    spec:
      containers:
      - name: backend
        image: localhost:5000/task-backend:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 5000
          name: http
        env:
        - name: FLASK_APP
          value: app.py
        - name: ENVIRONMENT
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: environment
        - name: DEBUG
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: debug
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 5000
          initialDelaySeconds: 10
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /health
            port: 5000
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 3
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
  namespace: default
  labels:
    app: task-app
    component: backend
spec:
  type: ClusterIP
  ports:
  - port: 5000
    targetPort: 5000
    protocol: TCP
    name: http
  selector:
    app: task-app
    component: backend
EOF

# Apply Frontend Deployment and Service
cat <<EOF | sudo k3s kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-deployment
  namespace: default
  labels:
    app: task-app
    component: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: task-app
      component: frontend
  template:
    metadata:
      labels:
        app: task-app
        component: frontend
    spec:
      containers:
      - name: frontend
        image: localhost:5000/task-frontend:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
        env:
        - name: REACT_APP_API_URL
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: api_url
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "250m"
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 3
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: default
  labels:
    app: task-app
    component: frontend
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
    protocol: TCP
    name: http
  selector:
    app: task-app
    component: frontend
EOF

sudo k3s kubectl set image deployment/backend-deployment backend=ch2314/app-back:latest
sudo k3s kubectl set image deployment/frontend-deployment frontend=ch2314/app-front:latest
sudo k3s kubectl rollout status deployment/backend-deployment --timeout=3m
sudo k3s kubectl rollout status deployment/frontend-deployment --timeout=3m
echo "Kubernetes updated successfully"