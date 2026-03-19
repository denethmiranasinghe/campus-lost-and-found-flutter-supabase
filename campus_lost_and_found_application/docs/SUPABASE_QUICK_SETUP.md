# Supabase Setup - Quick Reference

## ⚡ Quick Setup Steps

### Step 1: Execute Database Setup
1. Open Supabase Dashboard
2. Go to **SQL Editor** (left sidebar)
3. Click **"New query"**
4. Open the file: `docs/database_setup.sql`
5. **Copy ALL the content** from `database_setup.sql`
6. **Paste** into the SQL Editor
7. Click **"Run"** (or press Ctrl+Enter)
8. ✅ You should see "Success. No rows returned"

### Step 2: Create Storage Bucket
1. Go to **Storage** (left sidebar)
2. Click **"Create a new bucket"**
3. Enter bucket name: `item-images`
4. Toggle **"Public bucket"** to **ON**
5. Click **"Create bucket"**
6. ✅ Bucket created

### Step 3: Set Storage Policies
1. Stay in **Storage** section
2. Click on the `item-images` bucket
3. Go to **"Policies"** tab
4. Click **"New policy"**
5. Click **"Create policy from scratch"**
6. Open the file: `docs/storage_policies.sql`
7. For each policy in the file:
   - Copy the policy SQL
   - Paste into the policy editor
   - Click "Save"
8. ✅ All 4 policies created

### Step 4: Enable Realtime
1. Go to **Database** → **Replication** (left sidebar)
2. Find the `messages` table
3. Toggle **"Realtime"** to **ON**
4. Click **"Save"**
5. ✅ Realtime enabled

### Step 5: Update App Config
1. In Supabase, go to **Settings** → **API**
2. Copy your **Project URL**
3. Copy your **anon public** key
4. Open `lib/config/supabase_config.dart` in your project
5. Replace the placeholder values:
   ```dart
   static const String supabaseUrl = 'YOUR_PROJECT_URL_HERE';
   static const String supabaseAnonKey = 'YOUR_ANON_KEY_HERE';
   ```
6. Save the file
7. ✅ App configured

### Step 6: Create Admin User (Optional)
1. Register a user through the app first
2. Go to **Table Editor** in Supabase
3. Select the `users` table
4. Find the user you want to make admin
5. Click the edit icon
6. Change `role` from `student` to `admin`
7. Click **"Save"**
8. ✅ Admin user created

## 📋 Verification Checklist

After setup, verify:
- [ ] 4 tables exist: users, items, chats, messages
- [ ] All tables have RLS enabled (shield icon)
- [ ] Storage bucket `item-images` exists and is public
- [ ] Storage bucket has 4 policies
- [ ] Realtime is enabled for `messages` table
- [ ] App config file has real credentials (not placeholders)

## 🚨 Common Errors & Solutions

### Error: "relation does not exist"
**Solution:** You haven't created the tables yet. Run `docs/database_setup.sql`

### Error: "permission denied for table"
**Solution:** RLS policies not set correctly. Re-run the policies section of `docs/database_setup.sql`

### Error: "bucket does not exist"
**Solution:** Create the `item-images` bucket in Storage section first

### Error: "syntax error at or near #"
**Solution:** You're copying Markdown text. Use `docs/database_setup.sql` instead of `SUPABASE_SCHEMA.md`

### Error: Messages not appearing in real-time
**Solution:** Enable Realtime for `messages` table in Database → Replication

## 📁 Files to Use

- ✅ **docs/database_setup.sql** - Execute this in SQL Editor (Step 1)
- ✅ **docs/storage_policies.sql** - Use for storage policies (Step 3)
- ❌ **docs/SUPABASE_SCHEMA.md** - Documentation only, don't execute!

## ⏱️ Estimated Time

- Database setup: 2 minutes
- Storage setup: 2 minutes
- App configuration: 1 minute
- **Total: ~5 minutes**

## 🎯 You're Done When...

You can successfully:
1. Register a new user in the app
2. Login with that user
3. Create a new item post
4. Upload an image
5. Send a message
6. See the message appear in real-time

---

**Need more help?** See `SETUP_GUIDE.md` for detailed instructions.
