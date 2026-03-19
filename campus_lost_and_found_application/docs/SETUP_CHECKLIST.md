# Setup Checklist - Campus Lost and Found App

Use this checklist to ensure you've completed all setup steps correctly.

## ☐ Prerequisites

- [ ] Flutter SDK installed (version 3.10.4 or higher)
- [ ] Run `flutter doctor` and resolve any issues
- [ ] Android Studio or VS Code installed
- [ ] Git installed (optional, for version control)
- [ ] Supabase account created

## ☐ Project Setup

- [ ] Navigated to project directory
- [ ] Run `flutter pub get` successfully
- [ ] No dependency errors

## ☐ Supabase Configuration

### Create Project
- [ ] Created new Supabase project
- [ ] Project is fully initialized
- [ ] Copied Project URL
- [ ] Copied anon/public API key

### Update App Config
- [ ] Opened `lib/config/supabase_config.dart`
- [ ] Replaced `YOUR_SUPABASE_URL` with actual URL
- [ ] Replaced `YOUR_SUPABASE_ANON_KEY` with actual key
- [ ] Saved the file

## ☐ Database Setup

### Users Table
- [ ] Opened SQL Editor in Supabase
- [ ] Created `users` table
- [ ] Enabled RLS on `users` table
- [ ] Created policies for `users` table

### Items Table
- [ ] Created `items` table
- [ ] Enabled RLS on `items` table
- [ ] Created policies for `items` table
- [ ] Created indexes for `items` table

### Chats Table
- [ ] Created `chats` table
- [ ] Enabled RLS on `chats` table
- [ ] Created policies for `chats` table
- [ ] Created indexes for `chats` table

### Messages Table
- [ ] Created `messages` table
- [ ] Enabled RLS on `messages` table
- [ ] Created policies for `messages` table
- [ ] Created indexes for `messages` table

### Functions & Triggers
- [ ] Created `update_updated_at_column()` function
- [ ] Created trigger on `items` table

## ☐ Storage Setup

- [ ] Created `item-images` bucket
- [ ] Set bucket to public
- [ ] Created storage policies for viewing
- [ ] Created storage policies for uploading
- [ ] Created storage policies for deleting

## ☐ Realtime Setup

- [ ] Opened Database > Replication
- [ ] Enabled Realtime for `messages` table
- [ ] Saved changes

## ☐ Platform Configuration

### Android
- [ ] Opened `android/app/src/main/AndroidManifest.xml`
- [ ] Added INTERNET permission
- [ ] Added READ_EXTERNAL_STORAGE permission
- [ ] Added WRITE_EXTERNAL_STORAGE permission
- [ ] Verified minSdkVersion is 21 in build.gradle

### iOS (if applicable)
- [ ] Opened `ios/Runner/Info.plist`
- [ ] Added NSPhotoLibraryUsageDescription
- [ ] Added NSCameraUsageDescription

## ☐ Running the App

- [ ] Connected Android device or started emulator
- [ ] Run `flutter devices` to verify device
- [ ] Run `flutter run`
- [ ] App launches successfully
- [ ] No compilation errors

## ☐ Testing Features

### Authentication
- [ ] Register new account works
- [ ] Login with credentials works
- [ ] User profile is created in database
- [ ] Logout works
- [ ] Session persists on app restart

### Items
- [ ] Can create lost item
- [ ] Can create found item
- [ ] Can upload image
- [ ] Can view item details
- [ ] Can edit own item
- [ ] Can delete own item
- [ ] Search works
- [ ] Category filter works
- [ ] Pull-to-refresh works

### Messaging
- [ ] Can contact item owner
- [ ] Chat is created
- [ ] Can send message
- [ ] Message appears in real-time
- [ ] Chat list shows conversation
- [ ] Last message preview works

### Profile
- [ ] Profile displays user info
- [ ] Shows user's posted items
- [ ] Statistics are correct
- [ ] Can navigate to own items

### Admin (if admin account)
- [ ] Can access admin dashboard
- [ ] Can view all posts
- [ ] Can view all users
- [ ] Can delete any post
- [ ] Admin badge shows in UI

## ☐ Documentation Review

- [ ] Read README.md
- [ ] Reviewed SETUP_GUIDE.md
- [ ] Checked SUPABASE_SCHEMA.md
- [ ] Reviewed ARCHITECTURE.md
- [ ] Read PROJECT_SUMMARY.md

## ☐ Security

- [ ] Supabase credentials NOT committed to git
- [ ] `.gitignore` includes `supabase_config.dart`
- [ ] RLS policies tested and working
- [ ] Admin features only accessible to admins

## ☐ Final Checks

- [ ] No console errors
- [ ] All screens accessible
- [ ] Navigation works correctly
- [ ] Images load properly
- [ ] Forms validate correctly
- [ ] Error messages display properly
- [ ] Loading states work
- [ ] App doesn't crash

## ☐ Optional Enhancements

- [ ] Created admin user in database
- [ ] Added sample data for testing
- [ ] Tested on multiple devices
- [ ] Tested different screen sizes
- [ ] Performance is acceptable

## 🎉 Completion

When all items are checked:
- ✅ Your app is fully set up and functional
- ✅ Ready for development and testing
- ✅ Ready for academic submission
- ✅ Ready for demonstration

## 📝 Notes

Use this space to note any issues or customizations:

```
Issue: 
Solution: 

Issue: 
Solution: 

Issue: 
Solution: 
```

## 🆘 If Something Doesn't Work

1. Check the SETUP_GUIDE.md troubleshooting section
2. Verify all Supabase credentials are correct
3. Ensure all database tables and policies are created
4. Check Flutter doctor for environment issues
5. Review console logs for specific errors

---

**Tip**: Print this checklist and check items off as you complete them!
