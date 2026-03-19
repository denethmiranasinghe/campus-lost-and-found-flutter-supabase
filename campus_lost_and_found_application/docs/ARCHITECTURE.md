# Project Architecture - Campus Lost and Found App

## Overview

This document describes the architecture and design patterns used in the Campus Lost and Found application.

## Architecture Pattern

The application follows a **Provider-based MVVM (Model-View-ViewModel)** architecture pattern:

```
┌─────────────────────────────────────────────────────┐
│                    Presentation Layer                │
│                      (Screens/UI)                    │
└─────────────────────────────────────────────────────┘
                         ↕
┌─────────────────────────────────────────────────────┐
│                   Business Logic Layer               │
│                      (Providers)                     │
└─────────────────────────────────────────────────────┘
                         ↕
┌─────────────────────────────────────────────────────┐
│                      Data Layer                      │
│                  (Models + Supabase)                 │
└─────────────────────────────────────────────────────┘
```

## Layer Breakdown

### 1. Presentation Layer (Screens)

**Location**: `lib/screens/`

**Responsibility**: Display UI and handle user interactions

**Components**:
- Screens (StatefulWidget/StatelessWidget)
- Widgets (Reusable UI components)
- Forms and input handling
- Navigation

**Key Principles**:
- Screens are **stateful** when they need local UI state
- Screens **consume** providers using `Consumer` or `Provider.of()`
- Minimal business logic - delegate to providers
- Focus on UI rendering and user experience

### 2. Business Logic Layer (Providers)

**Location**: `lib/providers/`

**Responsibility**: Manage application state and business logic

**Providers**:

#### AuthProvider
- User authentication (login, register, logout)
- Session management
- User profile loading
- Role-based access control

#### ItemProvider
- CRUD operations for items
- Image upload to Supabase Storage
- Search and filter functionality
- Item state management

#### ChatProvider
- Real-time messaging
- Chat creation and management
- Message history
- Realtime subscriptions

**Key Principles**:
- Extends `ChangeNotifier` for state management
- Notifies listeners on state changes
- Handles all API calls to Supabase
- Error handling and loading states
- Single responsibility per provider

### 3. Data Layer (Models)

**Location**: `lib/models/`

**Responsibility**: Data structures and serialization

**Models**:

#### UserModel
```dart
- id: String
- email: String
- fullName: String
- role: String
- phoneNumber: String?
- createdAt: DateTime
```

#### ItemModel
```dart
- id: String
- userId: String
- title: String
- description: String
- category: String
- status: String (lost/found)
- location: String
- date: DateTime
- imageUrl: String?
- createdAt: DateTime
- updatedAt: DateTime
```

#### MessageModel & ChatModel
```dart
MessageModel:
- id: String
- chatId: String
- senderId: String
- receiverId: String
- message: String
- createdAt: DateTime
- isRead: Boolean

ChatModel:
- id: String
- userId1: String
- userId2: String
- lastMessage: String?
- lastMessageTime: DateTime?
- createdAt: DateTime
```

**Key Principles**:
- Immutable data classes
- JSON serialization (fromJson/toJson)
- Type safety
- Nullable fields where appropriate

## State Management Flow

### Provider Pattern

```
User Action (UI)
      ↓
Provider Method Called
      ↓
Update Loading State
      ↓
API Call to Supabase
      ↓
Update Data State
      ↓
notifyListeners()
      ↓
UI Rebuilds (Consumer)
```

### Example: Creating an Item

```dart
// 1. User fills form and clicks submit
onPressed: () => _handleSubmit()

// 2. Screen calls provider method
final success = await itemProvider.createItem(...)

// 3. Provider updates state
_isLoading = true;
notifyListeners();

// 4. Provider makes API call
await _supabase.from('items').insert(...)

// 5. Provider updates state again
_isLoading = false;
await fetchItems(); // Refresh list
notifyListeners();

// 6. UI rebuilds automatically
Consumer<ItemProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) return CircularProgressIndicator();
    return ItemsList(items: provider.items);
  }
)
```

## Navigation Flow

```
Splash Screen
      ↓
  [Auth Check]
      ↓
   ┌──────┴──────┐
   ↓             ↓
Login        Home Screen
   ↓             ↓
Register    ┌────┴────┬────────┬─────────┐
            ↓         ↓        ↓         ↓
        Post Item  Details  Chat    Profile
                      ↓        ↓         ↓
                   Edit     Messages  My Posts
```

### Route Management

Routes are defined in `main.dart`:

```dart
routes: {
  '/': (context) => SplashScreen(),
  '/login': (context) => LoginScreen(),
  '/home': (context) => HomeScreen(),
  ...
}
```

Dynamic routes with arguments:
```dart
onGenerateRoute: (settings) {
  if (settings.name == '/item-details') {
    final args = settings.arguments as Map;
    return MaterialPageRoute(
      builder: (context) => ItemDetailsScreen(item: args['item']),
    );
  }
}
```

## Data Flow Patterns

### 1. Authentication Flow

```
User enters credentials
      ↓
AuthProvider.login()
      ↓
Supabase Auth API
      ↓
Load user profile from database
      ↓
Update currentUser state
      ↓
Navigate to Home
```

### 2. Real-time Chat Flow

```
User opens chat
      ↓
ChatProvider.fetchMessages()
      ↓
ChatProvider.subscribeToMessages()
      ↓
Supabase Realtime Channel
      ↓
New message arrives
      ↓
Callback adds to messages list
      ↓
notifyListeners()
      ↓
UI updates automatically
```

### 3. Image Upload Flow

```
User selects image
      ↓
ImagePicker picks file
      ↓
ItemProvider.createItem(imageFile)
      ↓
Upload to Supabase Storage
      ↓
Get public URL
      ↓
Save URL in database
      ↓
Display image via CachedNetworkImage
```

## Security Architecture

### Row Level Security (RLS)

All database tables use RLS policies:

```sql
-- Users can only update their own data
CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

-- Admins can delete any item
CREATE POLICY "Admins can delete any item" ON items
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role = 'admin'
    )
  );
```

### Client-Side Security

- Authentication required for all sensitive operations
- Role-based UI rendering (admin features hidden for students)
- Input validation on all forms
- Secure credential storage (never in code)

## Error Handling Strategy

### Provider Level

```dart
try {
  // API operation
  await _supabase.from('items').insert(...);
  _errorMessage = null;
} catch (e) {
  _errorMessage = 'Failed to create item: $e';
} finally {
  _isLoading = false;
  notifyListeners();
}
```

### UI Level

```dart
if (success) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Success!'), backgroundColor: Colors.green),
  );
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(provider.errorMessage), backgroundColor: Colors.red),
  );
}
```

## Performance Optimizations

### 1. Image Caching
- Uses `cached_network_image` package
- Reduces network calls
- Improves scroll performance

### 2. Lazy Loading
- Items loaded on demand
- Pull-to-refresh for updates
- Pagination ready (can be implemented)

### 3. Efficient Rebuilds
- `Consumer` widgets only rebuild affected parts
- Selective `notifyListeners()` calls
- Const constructors where possible

### 4. Database Indexing
- Indexes on frequently queried columns
- Optimized JOIN queries
- Efficient RLS policies

## Testing Strategy

### Unit Tests
- Test provider methods
- Test model serialization
- Test business logic

### Widget Tests
- Test individual screens
- Test user interactions
- Test navigation

### Integration Tests
- Test complete user flows
- Test with mock Supabase client

## Scalability Considerations

### Current Architecture Supports:

✅ Adding new features (new providers/screens)
✅ Multiple user roles
✅ Real-time features
✅ Image uploads
✅ Search and filtering

### Future Enhancements:

- **Pagination**: Implement infinite scroll for large datasets
- **Caching**: Add local database (SQLite) for offline support
- **Push Notifications**: Integrate Firebase Cloud Messaging
- **Analytics**: Add Firebase Analytics or similar
- **Internationalization**: Add multi-language support

## Code Organization Best Practices

### File Naming
- `snake_case` for file names
- Descriptive names (e.g., `item_details_screen.dart`)
- Group related files in folders

### Code Style
- Follow Dart style guide
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused

### Dependency Management
- Minimize dependencies
- Use well-maintained packages
- Lock versions in pubspec.yaml

## Conclusion

This architecture provides:
- **Separation of Concerns**: Clear layer boundaries
- **Maintainability**: Easy to update and extend
- **Testability**: Each layer can be tested independently
- **Scalability**: Can grow with new features
- **Security**: Built-in security at database level
- **Real-time Capabilities**: Supabase Realtime integration

The Provider pattern combined with Supabase backend creates a robust, scalable foundation for the Campus Lost and Found application.
