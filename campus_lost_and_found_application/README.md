# Campus Lost and Found - Flutter Supabase App

A cross-platform mobile application that helps students report, search, and recover lost or found items efficiently on campus. Built with Flutter and Supabase.

## 🎯 Features

### User Features
- **Authentication**: Email and password-based registration and login
- **Lost & Found Posts**: Create, view, edit, and delete item posts
- **Search & Filter**: Search items by keywords and filter by category
- **Real-time Messaging**: One-to-one chat with item owners/finders
- **Image Upload**: Attach photos to item posts
- **User Profile**: View and manage your profile and posts

### Admin Features
- **Admin Dashboard**: View all posts and registered users
- **Content Moderation**: Delete inappropriate or fake posts
- **User Management**: View all registered users

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase
- **Database**: PostgreSQL (via Supabase)
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage
- **State Management**: Provider
- **Real-time**: Supabase Realtime

## 📱 Screens

1. **Splash Screen** - Initial loading screen
2. **Login Screen** - User authentication
3. **Register Screen** - New user registration
4. **Home Screen** - Browse lost and found items (tabbed)
5. **Post Item Screen** - Create new item posts
6. **Item Details Screen** - View full item information
7. **Edit Item Screen** - Modify existing posts
8. **Chat List Screen** - View all conversations
9. **Chat Screen** - Real-time messaging
10. **Profile Screen** - User profile and posts
11. **Admin Dashboard** - Admin moderation panel

## 📁 Project Structure

```
lib/
├── config/
│   └── supabase_config.dart          # Supabase configuration
├── models/
│   ├── user_model.dart                # User data model
│   ├── item_model.dart                # Item data model
│   └── message_model.dart             # Message and chat models
├── providers/
│   ├── auth_provider.dart             # Authentication state management
│   ├── item_provider.dart             # Items CRUD operations
│   └── chat_provider.dart             # Messaging functionality
├── screens/
│   ├── splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── items/
│   │   ├── post_item_screen.dart
│   │   ├── item_details_screen.dart
│   │   └── edit_item_screen.dart
│   ├── chat/
│   │   ├── chat_list_screen.dart
│   │   └── chat_screen.dart
│   ├── profile/
│   │   └── profile_screen.dart
│   └── admin/
│       └── admin_dashboard_screen.dart
├── widgets/
│   └── item_card.dart                 # Reusable item card widget
└── main.dart                          # App entry point
```

## 🚀 Quick Start (One-Click)

We've created a script to automatically clean, fix, and run the app for you.

1. **Run the repair & launch script:**
   ```powershell
   .\fix_and_run.ps1
   ```

2. **Wait for the app to launch!** (The first build may take a few minutes)

## 🛠 Manual Setup

### Prerequisites

- Flutter SDK (3.10.4 or higher)
- Dart SDK
- Android Studio / VS Code
- Supabase account

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd campus_lost_and_found_application
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   
   a. Create a new project at [supabase.com](https://supabase.com)
   
   b. Go to Project Settings > API to get your credentials
   
   c. Update `lib/config/supabase_config.dart`:
   ```dart
   class SupabaseConfig {
     static const String supabaseUrl = 'YOUR_SUPABASE_URL';
     static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   }
   ```

4. **Set up the database**
   
   - Open the SQL Editor in your Supabase dashboard
   - Copy and execute the SQL from `docs/database_setup.sql`
   - This will create all necessary tables, policies, and storage buckets

5. **Run the app**
   ```bash
   flutter run
   ```

## 🗄️ Database Schema

The application uses the following database tables:

- **users**: User profiles and authentication data
- **items**: Lost and found item posts
- **chats**: Chat conversations between users
- **messages**: Individual messages in chats

For detailed schema information, see [SUPABASE_SCHEMA.md](docs/SUPABASE_SCHEMA.md)

## 🔐 Authentication Flow

1. User registers with email and password
2. Supabase Auth creates authentication record
3. User profile is created in the `users` table
4. Default role is set to 'student'
5. User can login with credentials
6. Session is maintained across app restarts

## 👨‍💼 Creating an Admin User

After registering a user, promote them to admin using SQL:

```sql
UPDATE users 
SET role = 'admin' 
WHERE email = 'admin@example.com';
```

## 📸 Image Upload

Images are stored in Supabase Storage:
- Bucket name: `item-images`
- Public access enabled
- Automatic URL generation
- Supports common image formats

## 💬 Real-time Messaging

The chat system uses Supabase Realtime:
- Instant message delivery
- Message read status
- Chat history
- Timestamped messages

## 🎨 UI/UX Features

- Material Design components
- Responsive layouts
- Loading states
- Error handling
- Pull-to-refresh
- Image caching
- Form validation
- Confirmation dialogs

## 📦 Dependencies

Key packages used:
- `supabase_flutter`: Supabase client
- `provider`: State management
- `image_picker`: Image selection
- `cached_network_image`: Image caching
- `intl`: Date formatting
- `timeago`: Relative time display

## 🔧 Configuration

### Android
Minimum SDK: 21 (Android 5.0)

Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to upload item images</string>
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take item photos</string>
```

## 🐛 Troubleshooting

### Common Issues

1. **Supabase connection error**
   - Verify your URL and anon key in `supabase_config.dart`
   - Check internet connection

2. **Image upload fails**
   - Ensure storage bucket is created
   - Check storage policies are set correctly

3. **Messages not appearing in real-time**
   - Verify Realtime is enabled in Supabase project settings
   - Check network connection

## 📝 Future Enhancements

- Push notifications for new messages
- Advanced search with filters
- Item claim verification
- Email notifications
- User ratings and reviews
- Location-based search
- Dark mode support
- Multi-language support

## 👥 User Roles

### Student
- Create, edit, delete own posts
- View all posts
- Message other users
- Manage own profile

### Admin
- All student permissions
- View all users
- Delete any post
- Access admin dashboard

## 🔒 Security

- Row Level Security (RLS) enabled on all tables
- Authentication required for sensitive operations
- User can only modify own data
- Admin role required for moderation
- Secure image storage with access policies

## 📄 License

This project is created for educational purposes as a 3rd year Software Engineering assignment.

## 🤝 Contributing

This is an individual assignment project. For educational reference only.

## 📧 Support

For issues or questions, please refer to the course instructor or teaching assistants.

---

**Note**: Remember to never commit your `supabase_config.dart` file with real credentials to version control. Add it to `.gitignore` and use environment variables for production.
