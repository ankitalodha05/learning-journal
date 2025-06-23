**Creating and Exploring a Multi-Container Pod in Kubernetes**

This guide explains how to create a multi-container pod using BusyBox containers, share volumes between them, and verify the pod behavior using basic `kubectl` commands in a KillerCoda Kubernetes playground.

---

### **Step-by-Step Procedure:**

#### **1. Initialize the Kubernetes Playground**

Once the playground is ready:

```
Initialising Kubernetes... done
```

#### **2. Create a Pod Definition File**

Create a file called `pod.yaml`:

```bash
nano pod.yaml
```

Paste the following YAML configuration into the file:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-container
spec:
  volumes:
    - name: mdak-emptydir
      emptyDir: {}

  containers:
    - name: busybox-1
      image: busybox
      command: ["sleep", "36000"]
      volumeMounts:
        - name: mdak-emptydir
          mountPath: /shared-folder

    - name: busybox-2
      image: busybox
      command: ["sleep", "36000"]
      volumeMounts:
        - name: mdak-emptydir
          mountPath: /shared-folder
```

#### **3. Apply the YAML to Create the Pod**

```bash
kubectl apply -f pod.yaml
```

**Output:**

```
pod/multi-container created
```

#### **4. Verify Cluster and Pod Status**

```bash
kubectl get nodes
kubectl get pod
```

**Output:**

```
NAME              READY   STATUS    RESTARTS   AGE
multi-container   2/2     Running   0          18s
```

#### **5. Describe the Pod for Detailed Info**

```bash
kubectl describe pod
```

Check important details such as:

* Containers info
* Volume mounts
* Status and Events

#### **6. Debugging an Exec Error**

If you run:

```bash
kubectl exec -it multi-container -c busybox-1
```

You’ll get:

```
error: you must specify at least one command for the container
```

**Fix:** Provide a command (like `sh`):

```bash
kubectl exec -it multi-container -c busybox-1 -- sh
```

#### **7. Test Shared Volume Functionality**

Inside the container shell:

```bash
/ # cd /shared-folder/
/shared-folder # touch multi-containor.txt
/shared-folder # ls
multi-containor.txt
```

This confirms the volume `/shared-folder` is writable and shared between both containers.

---

### **Explanation:**

* **Multi-Container Pod:** Hosts two containers (`busybox-1`, `busybox-2`) in one pod.
* **Shared Volume:** `emptyDir` allows both containers to read/write files into a shared directory.
* **Command **\`\`**:** Keeps both containers running for a long time.
* **VolumeMount:** `/shared-folder` is the path inside each container where the volume is mounted.

---

### **Conclusion:**

This setup demonstrates how to create and manage multi-container pods in Kubernetes and use shared volumes for inter-container communication. This pattern is useful for sidecar containers or tightly-coupled microservices.
