# Linux Disk Management

## Expanding an Attached Disk Volume
When you increase the size of an attached disk using the **AWS Console** or **CLI**, Linux may not automatically recognize the new space. You need to update the volume usage with the following commands:

```bash
sudo growpart /dev/xvda 1  
```
- This resizes the partition to use the new available space.  

OR  

```bash
sudo resize2fs /dev/xvda1  
```
- This resizes the filesystem inside the partition to use the full space.  

---

## Attaching a New Disk to an EC2 Instance

### Important Notes
- The new disk (EBS Volume) **must be created in the same Availability Zone (AZ)** as the EC2 instance.
- If the volume is in a **different AZ**, you **cannot** attach it directly.
  - **Solution:** Create a **snapshot** of the volume, then create a new volume from that snapshot in the correct AZ.

---

## Mounting the New Disk in Linux

### Step 1: Check if the new disk is detected
```bash
lsblk
```
- Lists all attached block devices, including newly added disks.

```bash
df -h
```
- Shows current disk usage and mounted file systems.

### Step 2: Format the Disk (If Not Already Formatted)
```bash
sudo mkfs.ext4 /dev/xvdb
```
- Formats the disk with the **ext4** file system.
- You can use other file systems if needed:
  - **ext4** – General-purpose, widely used in Linux.
  - **xfs** – High performance, good for large-scale data.
  - **ntfs** – Used in Windows environments.

### Step 3: Create a Mount Directory
```bash
sudo mkdir /mnt/volume
```
- Creates a directory to use as the **mount point** (where the disk is accessed).
- You can replace `/mnt/volume` with another location (e.g., `/data`).

### Step 4: Mount the Disk
```bash
sudo mount /dev/xvdb /mnt/volume
```
- Mounts the disk at `/mnt/volume`.

---

## Understanding Mount Points
- A **mount point** is a directory where you can access the contents of a storage device.
- After mounting, you can use `/mnt/volume` like any other directory.

### Why Create `/mnt/volume`?
- Linux needs a specific location to attach external volumes.
- `/mnt` is a standard location for temporary mounts, but you can use other paths like `/data` or `/storage`.

---

## Making the Mount Persistent (Permanent Mounting)

### Temporary Mounting (Default Behavior)
- The mount **only lasts until reboot**.
- After a system restart, the volume must be mounted again manually.

### Permanent Mounting (Automatically Mount at Boot)
To ensure the disk mounts automatically after reboot:

1. Edit the `/etc/fstab` file:
```bash
sudo vi /etc/fstab
```
2. Add the following line:
```
/dev/xvdb /mnt/volume ext4 defaults,nofail 0 2
```

### Explanation of Each Field
- `/dev/xvdb` → The disk name.
- `/mnt/volume` → The mount location.
- `ext4` → The filesystem type.
- `defaults` → Standard mount options.
- `nofail` → Prevents system boot issues if the disk is missing.
- `0 2` → File system check priority (0 = do not check, 2 = check after root).

### Apply the Changes Without Rebooting
```bash
sudo mount -a
```
- This mounts all volumes listed in `/etc/fstab`.

### Verify the Mount
```bash
df -h
```
- This ensures the volume is properly mounted.

---

## Additional Notes
- **Always double-check the disk name (`/dev/xvdb`) before running commands.**
- **If the volume already has data, do NOT format it (`mkfs.ext4`), or you will lose all data!**
- **To unmount a disk:**
```bash
sudo umount /mnt/volume
