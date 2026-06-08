# Validation Instructions

## Prerequisites

1. Create a Kind cluster using the provided configuration:

```bash
kind create cluster --config cluster.yml
```

2. Deploy all resources:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

## 1. Validate that the app is running

Check that all pods are in `Running` state:

```bash
kubectl get pods -n todoapp
```

Check deployment status:

```bash
kubectl get deployment todoapp -n todoapp
```

Verify health endpoints from inside a pod:

```bash
kubectl exec -n todoapp deploy/todoapp -- curl -s http://localhost:8080/api/health
kubectl exec -n todoapp deploy/todoapp -- curl -s http://localhost:8080/api/ready
```

Access the application in a browser via NodePort:

```
http://localhost:30007
```

## 2. Validate ConfigMap data is mounted as files in the right order

List mounted ConfigMap files:

```bash
kubectl exec -n todoapp deploy/todoapp -- ls -1 /app/configs
```

Expected output (alphabetical order):

```
PYTHONUNBUFFERED
```

Verify file content:

```bash
kubectl exec -n todoapp deploy/todoapp -- cat /app/configs/PYTHONUNBUFFERED
```

Expected output:

```
1
```

Verify the mount is read-only:

```bash
kubectl exec -n todoapp deploy/todoapp -- sh -c "touch /app/configs/test 2>&1"
```

The command should fail with a read-only filesystem error.

## 3. Validate Secret data is mounted as a file

List mounted Secret files:

```bash
kubectl exec -n todoapp deploy/todoapp -- ls -1 /app/secrets
```

Expected output:

```
SECRET_KEY
```

Verify that the secret file exists and is not empty:

```bash
kubectl exec -n todoapp deploy/todoapp -- test -s /app/secrets/SECRET_KEY && echo "Secret file is mounted"
```

Verify the mount is read-only:

```bash
kubectl exec -n todoapp deploy/todoapp -- sh -c "touch /app/secrets/test 2>&1"
```

The command should fail with a read-only filesystem error.

## 4. Validate PersistentVolume and PersistentVolumeClaim

Check that PV and PVC are bound:

```bash
kubectl get pv todoapp-pv
kubectl get pvc todoapp-pvc -n todoapp
```

Verify the data volume is mounted:

```bash
kubectl exec -n todoapp deploy/todoapp -- ls -ld /app/data
```

Write a test file to confirm the volume is writable:

```bash
kubectl exec -n todoapp deploy/todoapp -- sh -c "echo test > /app/data/persistence-check.txt && cat /app/data/persistence-check.txt"
```
