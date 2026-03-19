# Setup Guide - Campus Lost and Found App

This guide will walk you through setting up the Campus Lost and Found application from scratch.

## Step 1: Prerequisites

Before you begin, ensure you have:

- [ ] Flutter SDK installed (version 3.10.4 or higher)
- [ ] Android Studio or VS Code with Flutter extensions
- [ ] Git installed
- [ ] A Supabase account (free tier is sufficient)

### Verify Flutter Installation

```bash
flutter --version
flutter doctor
```

## Step 2: Project Setup

### 2.1 Navigate to Project Directory

```bash
cd e:\Projects\campus-lost-and-found-flutter-supabase\campus_lost_and_found_application
```

### 2.2 Install Dependencies

```bash
flutter pub get
```

This will install all required packages including:
- supabase_flutter
- provider
- image_picker
- cached_network_image
- intl
- timeago

## Step 3: Supabase Setup

### 3.1 Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign in or create an account
3. Click "New Project"
4. Fill in the details:
   - **Name**: Campus Lost and Found
   - **Database Password**: Choose a strong password (save it!)
   - **Region**: Choose closest to your location
5. Click "Create new project"
6. Wait for the project to be set up (takes 1-2 minutes)

### 3.2 Get Your API Credentials

1. In your Supabase project dashboard, go to **Settings** (gear icon)
2. Click on **API** in the left sidebar
3. Copy the following:
   - **Project URL** (under "Project URL")
   - **anon public** key (under "Project API keys")

### 3.3 Configure the App

1. Open `lib/config/supabase_config.dart`
2. Replace the placeholder values:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://your-project-id.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
}
```

## Step 4: Database Setup

### 4.1 Create Database Tables

1. In your Supabase dashboard, click on **SQL Editor** (left sidebar)
2. Click "New query"
3. Open the `SUPABASE_SCHEMA.md` file in this project
4. Copy the SQL for the **users** table and execute it
5. Repeat for **items**, **chats**, and **messages** tables
6. Execute the functions and triggers

### 4.2 Create Storage Bucket

1. Go to **Storage** in the Supabase dashboard
2. Click "Create a new bucket"
3. Name it: `item-images`
4. Make it **public**
5. Click "Create bucket"
6. Go to **Policies** tab
7. Execute the storage policies from `SUPABASE_SCHEMA.md`

### 4.3 Enable Realtime (for Chat)

1. Go to **Database** > **Replication** in Supabase dashboard
2. Find the `messages` table
3. Toggle **Realtime** to ON
4. Click "Save"

## Step 5: Platform-Specific Configuration

### Android Configuration

1. Open `android/app/src/main/AndroidManifest.xml`
2. Add these permissions inside `<manifest>` tag:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

3. Ensure minimum SDK is set to 21 in `android/app/build.gradle`:

```gradle
minSdkVersion 21
```

### iOS Configuration (if building for iOS)

1. Open `ios/Runner/Info.plist`
2. Add these keys before `</dict>`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to upload item images</string>
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take item photos</string>
```

## Step 6: Run the Application

### 6.1 Connect a Device or Emulator

**For Android:**
- Connect a physical device via USB with USB debugging enabled, OR
- Start an Android emulator from Android Studio

**For iOS (Mac only):**
- Connect an iPhone/iPad, OR
- Start an iOS simulator

### 6.2 Verify Device Connection

```bash
flutter devices
```

You should see your connected device/emulator listed.

### 6.3 Run the App

```bash
flutter run
```

Or in VS Code/Android Studio, press F5 or click the Run button.

## Step 7: Create Your First User

### 7.1 Register a Student Account

1. When the app launches, you'll see the splash screen
2. Click "Register"
3. Fill in:
   - Full Name: Your Name
   - Email: your.email@example.com
   - Phone: (optional)
   - Password: Choose a secure password
   - Confirm Password: Same as above
4. Click "Register"
5. You should be logged in automatically

### 7.2 Create an Admin Account

To test admin features:

1. Register another account through the app
2. Go to Supabase dashboard > **Table Editor**
3. Select the `users` table
4. Find the user you want to make admin
5. Edit the row and change `role` from `student` to `admin`
6. Save changes
7. Log out and log back in with that account

## Step 8: Test the Application

### Test Checklist

- [ ] **Authentication**
  - [ ] Register new account
  - [ ] Login with credentials
  - [ ] Logout

- [ ] **Items**
  - [ ] Create a lost item post
  - [ ] Create a found item post
  - [ ] Upload an image
  - [ ] View item details
  - [ ] Edit your own post
  - [ ] Delete your own post
  - [ ] Search items
  - [ ] Filter by category

- [ ] **Messaging**
  - [ ] Contact an item owner
  - [ ] Send messages
  - [ ] Receive messages in real-time
  - [ ] View chat list

- [ ] **Profile**
  - [ ] View your profile
  - [ ] See your posted items
  - [ ] View statistics

- [ ] **Admin (if admin account)**
  - [ ] Access admin dashboard
  - [ ] View all posts
  - [ ] View all users
  - [ ] Delete inappropriate posts

## Step 9: Troubleshooting

### Issue: "Supabase connection failed"

**Solution:**
- Check your internet connection
- Verify the URL and anon key in `supabase_config.dart`
- Ensure the Supabase project is active

### Issue: "Image upload failed"

**Solution:**
- Verify the `item-images` bucket exists
- Check storage policies are set correctly
- Ensure the bucket is public

### Issue: "Messages not appearing in real-time"

**Solution:**
- Enable Realtime for the `messages` table in Supabase
- Check network connection
- Restart the app

### Issue: "Build failed"

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: "Permission denied for image picker"

**Solution:**
- Check AndroidManifest.xml has required permissions
- For iOS, check Info.plist has camera/photo permissions
- Grant permissions when prompted on device

## Step 10: Development Tips

### Hot Reload

While the app is running, make code changes and press:
- `r` in terminal for hot reload
- `R` for hot restart

### Debugging

- Use `print()` statements for debugging
- Check Flutter DevTools for performance
- Monitor Supabase logs for backend issues

### Database Changes

If you modify the database schema:
1. Update the SQL in Supabase
2. Update the corresponding model classes
3. Update provider methods if needed

## Next Steps

Now that your app is set up:

1. **Customize**: Modify colors, themes, and branding
2. **Extend**: Add new features like notifications
3. **Test**: Test on different devices and screen sizes
4. **Deploy**: Prepare for production deployment

## Important Security Notes

⚠️ **Never commit your Supabase credentials to version control!**

Add to `.gitignore`:
```
lib/config/supabase_config.dart
```

For production, use environment variables or Flutter's build configurations.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Documentation](https://supabase.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

## Support

For issues specific to this project:
1. Check the README.md
2. Review SUPABASE_SCHEMA.md
3. Consult your course instructor

---

**Congratulations!** 🎉 Your Campus Lost and Found app is now set up and running!
