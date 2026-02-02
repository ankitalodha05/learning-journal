# Docker Disk Space Cleanup + Weekly Prune (Production-Safe Runbook)

## Problem / Issue (Why this happens)

On long-running servers, Docker can silently consume disk due to:
- **Unused images** (old builds, dangling tags)
- **Build cache** (especially from CI/CD builds)
- **Stopped containers**
- **Unused volumes** (sometimes large)
- **Old logs** (container JSON logs)

**Symptoms you’ll see**
- Deployments fail with `no space left on device`
- `docker pull` / `docker build` fails
- Server root disk (/) becomes 90–100% full

This document is a **production-safe** way to:
1) **Check** what is consuming space  
2) **Clean** safely without impacting running containers  
3) **Automate** weekly cleanup using a cron job

---

## Safety Rules (Read this once)

✅ Safe:
- Removing **stopped** containers
- Removing **unused** images (not used by any container)
- Clearing **build cache**
- Removing **unused networks**

⚠️ High risk:
- Removing **volumes** can delete persistent data (DBs, uploads, etc.)
- `docker system prune --volumes` should be used **only if you are 100% sure**

---

## Step 1: Quick Disk Check (OS level)

```bash
df -h
````

(Optional) See top disk usage folders:

```bash
sudo du -xh / | sort -h | tail -n 30
```

---

## Step 2: Docker Space Investigation (What is taking space)

### 2.1 Docker overall usage

```bash
docker system df
```

More detailed:

```bash
docker system df -v
```

### 2.2 Running containers (confirm what must NOT be impacted)

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
```

### 2.3 All containers (including stopped)

```bash
docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'
```

### 2.4 Images list (check old/unused)

```bash
docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}'
```

### 2.5 Volumes (handle carefully!)

```bash
docker volume ls
docker volume ls -qf dangling=true
```

---

## Step 3: Production-Safe Cleanup (Manual)

### 3.1 Remove stopped containers only (safe)

```bash
docker container prune -f
```

### 3.2 Remove unused networks (safe)

```bash
docker network prune -f
```

### 3.3 Remove dangling images (safe)

Dangling images are untagged layers not referenced.

```bash
docker image prune -f
```

### 3.4 Remove ALL unused images (safe for running containers)

This removes images not used by any container (running or stopped).

```bash
docker image prune -a -f
```

### 3.5 Clear build cache (safe)

```bash
docker builder prune -a -f
```

### 3.6 One-command safe cleanup (recommended)

This combines safe parts:

* stopped containers
* unused images
* unused networks
* build cache

✅ Does **NOT** remove volumes

```bash
docker system prune -a -f
```

---

## Step 4: Post-Cleanup Verification

```bash
df -h
docker system df
docker ps --format 'table {{.Names}}\t{{.Status}}'
```

---

## Step 5: Automation (Weekly Cron Job) — Production Safe

### 5.1 Create a cleanup script (recommended)

Why script?

* easier to audit
* consistent logs
* safe to reuse on any server

Create file:

```bash
sudo nano /usr/local/bin/docker-weekly-prune.sh
```

Paste this:

```bash
#!/bin/bash
set -euo pipefail

echo "===== $(date -u) : Docker Weekly Prune Started ====="

echo "## Before:"
docker system df || true

echo "## Pruning stopped containers, unused images, build cache, and networks (NO VOLUMES):"
docker system prune -a -f

echo "## After:"
docker system df || true

echo "===== $(date -u) : Docker Weekly Prune Completed ====="
```

Make it executable:

```bash
sudo chmod +x /usr/local/bin/docker-weekly-prune.sh
```

Test-run once:

```bash
sudo /usr/local/bin/docker-weekly-prune.sh
```

---

## Step 6: Add Cron Schedule

### 6.1 Understand the cron timing

`0 3 * * 0` means:

* `0`   → minute (00)
* `3`   → hour (03 AM)
* `*`   → day of month (every day)
* `*`   → month (every month)
* `0`   → day of week (Sunday)

So it runs: **Every Sunday at 03:00 AM**

### 6.2 Add cron entry (copy-paste safe)

This keeps existing cron entries and adds one new line:

```bash
(crontab -l 2>/dev/null; echo "0 3 * * 0 /usr/local/bin/docker-weekly-prune.sh >> /var/log/docker-weekly-prune.log 2>&1") | crontab -
```

Check it:

```bash
crontab -l
```

Check logs later:

```bash
tail -n 50 /var/log/docker-weekly-prune.log
```

---

## Notes / Best Practices

### Avoid deleting data volumes accidentally

Do **NOT** automate this unless you are 100% sure:

```bash
# dangerous - removes unused volumes (can delete DB data)
docker system prune -a -f --volumes
```

### If containers generate huge logs

Check log size (common issue in production):

```bash
sudo du -sh /var/lib/docker/containers/*/*-json.log 2>/dev/null | sort -h | tail -n 20
```

(If logs are huge, consider Docker log rotation in daemon config. That is separate from prune.)

---

## Interview-ready Explanation (2–3 lines)

When Docker hosts run for weeks, unused images and build cache accumulate and fill disk, causing `docker pull/build` failures.
I first verify usage using `df -h` and `docker system df -v`, confirm running containers with `docker ps`, then safely reclaim space using `docker system prune -a -f` (no volumes).
Finally, I automate weekly pruning via a script + cron (`0 3 * * 0`) with logs stored under `/var/log/docker-weekly-prune.log`.
