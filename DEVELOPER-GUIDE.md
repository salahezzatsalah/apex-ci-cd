# 🚀 APEX CI/CD Ultimate Guide

This guide covers both the **initial setup** and the **daily workflow**.

---

## 🛠️ Section 1: One-Time Setup (From Zero)
If you are starting a fresh project, follow these commands **once**:

1. **Initialize the Project Structure:**
   ```sql
   -- Inside SQLcl
   project init -name MyProject -version 1.0.0
   ```

2. **Register existing Production objects (Baseline Sync):**
   Connect to **Production** (`WKSP_ELWAGHA50`) and run:
   ```sql
   lb changelog-sync -changelog-file dist/releases/main.changelog.xml -search-path "."
   ```

---

## 🏗️ Section 2: Daily Workflow (Adding Changes)
Follow these steps every time you want to deploy a new feature:

### 1. Create a New Branch (PowerShell)
```powershell
git checkout main
git pull origin main
git checkout -b feature/your-feature-name
```

### 2. Make Database Changes (SQLcl)
```sql
connect DEV_SCHEMA/"Ecdtai@dev123"@armadadev_tp

-- 1. Create your new object
CREATE TABLE YOUR_TABLE_NAME ( id NUMBER PRIMARY KEY );

-- 2. Export & Stage (CRITICAL)
project export -verbose
project stage -verbose
exit
```

### 3. Push to GitHub (PowerShell)
```powershell
git add .
git commit -m "Ultra-final test for the CI/CD machine"
git push -u origin feature/your-feature-name
```

---

## ✅ Section 3: Final Step
1. Go to GitHub and open/merge the **Pull Request**.
2. Check the **Actions** tab on GitHub.
3. Your work is now automatically in **Production**! 🚀

**You are now a CI/CD Champion!** 🥇🏆🚀✨🦾🥇🏁🕺



