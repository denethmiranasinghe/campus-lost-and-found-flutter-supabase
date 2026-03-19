# Visual Guide - Campus Lost and Found App

## 📱 App Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      SPLASH SCREEN                          │
│                   (Authentication Check)                     │
└────────────────────┬────────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│  LOGIN SCREEN   │     │   HOME SCREEN   │
│                 │     │  (Authenticated) │
└────────┬────────┘     └────────┬────────┘
         │                       │
         │                       ├──────────────┐
         ▼                       │              │
┌─────────────────┐             │              │
│ REGISTER SCREEN │             │              │
└─────────────────┘             │              │
                                │              │
         ┌──────────────────────┼──────────────┼─────────────┐
         │                      │              │             │
         ▼                      ▼              ▼             ▼
┌─────────────────┐   ┌─────────────────┐  ┌──────────┐  ┌──────────┐
│  POST ITEM      │   │  ITEM DETAILS   │  │ CHAT     │  │ PROFILE  │
│  SCREEN         │   │  SCREEN         │  │ LIST     │  │ SCREEN   │
└────────┬────────┘   └────────┬────────┘  └────┬─────┘  └──────────┘
         │                     │                 │
         │                     ▼                 ▼
         │            ┌─────────────────┐  ┌──────────┐
         │            │  EDIT ITEM      │  │ CHAT     │
         │            │  SCREEN         │  │ SCREEN   │
         │            └─────────────────┘  └──────────┘
         │
         ▼
┌─────────────────┐
│ ADMIN DASHBOARD │ (Admin Only)
└─────────────────┘
```

## 🏗️ Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Splash  │  │  Auth    │  │  Home    │  │  Items   │   │
│  │  Screen  │  │  Screens │  │  Screen  │  │  Screens │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                 │
│  │  Chat    │  │  Profile │  │  Admin   │                 │
│  │  Screens │  │  Screen  │  │  Screen  │                 │
│  └──────────┘  └──────────┘  └──────────┘                 │
└────────────────────────┬────────────────────────────────────┘
                         │ Uses Provider.of() / Consumer
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   BUSINESS LOGIC LAYER                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │    Auth      │  │    Item      │  │    Chat      │     │
│  │   Provider   │  │   Provider   │  │   Provider   │     │
│  │              │  │              │  │              │     │
│  │ - login()    │  │ - create()   │  │ - send()     │     │
│  │ - register() │  │ - update()   │  │ - fetch()    │     │
│  │ - logout()   │  │ - delete()   │  │ - subscribe()│     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└────────────────────────┬────────────────────────────────────┘
                         │ Calls Supabase API
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │    User      │  │    Item      │  │   Message    │     │
│  │    Model     │  │    Model     │  │    Model     │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │              SUPABASE BACKEND                       │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐         │    │
│  │  │   Auth   │  │ Database │  │ Storage  │         │    │
│  │  └──────────┘  └──────────┘  └──────────┘         │    │
│  │  ┌──────────┐                                      │    │
│  │  │ Realtime │                                      │    │
│  │  └──────────┘                                      │    │
│  └────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## 🗄️ Database Schema Diagram

```
┌─────────────────────┐
│       USERS         │
├─────────────────────┤
│ id (PK)             │◄──────────┐
│ email               │           │
│ full_name           │           │
│ role                │           │
│ phone_number        │           │
│ created_at          │           │
└─────────────────────┘           │
         ▲                        │
         │                        │
         │                        │
         │                        │
┌────────┴────────────┐           │
│       ITEMS         │           │
├─────────────────────┤           │
│ id (PK)             │           │
│ user_id (FK)        │───────────┘
│ title               │
│ description         │
│ category            │
│ status              │
│ location            │
│ date                │
│ image_url           │
│ created_at          │
│ updated_at          │
└─────────────────────┘


┌─────────────────────┐
│       CHATS         │
├─────────────────────┤
│ id (PK)             │◄──────────┐
│ user_id_1 (FK)      │───┐       │
│ user_id_2 (FK)      │───┼───────┼──► USERS
│ last_message        │   │       │
│ last_message_time   │   │       │
│ created_at          │   │       │
└─────────────────────┘   │       │
         ▲                │       │
         │                │       │
         │                │       │
┌────────┴────────────┐   │       │
│     MESSAGES        │   │       │
├─────────────────────┤   │       │
│ id (PK)             │   │       │
│ chat_id (FK)        │───┘       │
│ sender_id (FK)      │───────────┘
│ receiver_id (FK)    │───────────► USERS
│ message             │
│ is_read             │
│ created_at          │
└─────────────────────┘
```

## 🔄 State Management Flow

```
┌──────────────────────────────────────────────────────────┐
│                    USER ACTION                           │
│              (Button Press, Form Submit)                 │
└────────────────────────┬─────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────┐
│                  SCREEN WIDGET                           │
│         Calls Provider Method                            │
│         itemProvider.createItem(...)                     │
└────────────────────────┬─────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────┐
│                    PROVIDER                              │
│  1. Set _isLoading = true                               │
│  2. notifyListeners()                                   │
└────────────────────────┬─────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────┐
│                 SUPABASE API CALL                        │
│         await _supabase.from('items').insert(...)       │
└────────────────────────┬─────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────┐
│                    PROVIDER                              │
│  3. Update data (_items list)                           │
│  4. Set _isLoading = false                              │
│  5. notifyListeners()                                   │
└────────────────────────┬─────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────┐
│                 CONSUMER WIDGET                          │
│         Automatically Rebuilds UI                        │
│         Shows Updated Data                               │
└──────────────────────────────────────────────────────────┘
```

## 📱 Screen Components Breakdown

### Home Screen
```
┌─────────────────────────────────────┐
│  ┌─────────────────────────────┐   │
│  │      App Bar                 │   │
│  │  [Menu] Campus L&F [Chat][👤]│   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │   [Lost Items] [Found Items] │   │ ◄── Tabs
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │   🔍 Search items...         │   │ ◄── Search
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ [All][Electronics][Books]... │   │ ◄── Filters
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │  ┌─────────────────────┐    │   │
│  │  │   Item Card 1       │    │   │
│  │  │   [Image]           │    │   │ ◄── Item List
│  │  │   Title             │    │   │
│  │  │   Description...    │    │   │
│  │  └─────────────────────┘    │   │
│  │  ┌─────────────────────┐    │   │
│  │  │   Item Card 2       │    │   │
│  │  └─────────────────────┘    │   │
│  └─────────────────────────────┘   │
│                                     │
│              [+ Post Item]          │ ◄── FAB
└─────────────────────────────────────┘
```

### Chat Screen
```
┌─────────────────────────────────────┐
│  ┌─────────────────────────────┐   │
│  │ [←] John Doe                │   │ ◄── App Bar
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │      Today                   │   │ ◄── Date Separator
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────┐       │
│  │ Hello! Is this still    │       │ ◄── Received
│  │ available?              │       │     Message
│  │ 10:30 AM                │       │
│  └─────────────────────────┘       │
│                                     │
│       ┌─────────────────────────┐  │
│       │ Yes, it is!             │  │ ◄── Sent
│       │ 10:32 AM                │  │     Message
│       └─────────────────────────┘  │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Type a message...      [📎] │   │ ◄── Input
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

## 🔐 Security Flow

```
┌──────────────────────────────────────────────────────────┐
│                   CLIENT REQUEST                         │
│          (User tries to access/modify data)              │
└────────────────────────┬─────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────┐
│              SUPABASE AUTH CHECK                         │
│          Is user authenticated?                          │
└────────┬────────────────────────────┬────────────────────┘
         │ NO                         │ YES
         ▼                            ▼
┌─────────────────┐      ┌────────────────────────────────┐
│  REJECT         │      │    ROW LEVEL SECURITY (RLS)    │
│  Return 401     │      │    Check policies              │
└─────────────────┘      └────────┬───────────────────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    │ Policy Check              │
                    ▼                           ▼
         ┌──────────────────┐      ┌──────────────────┐
         │  ALLOW           │      │  DENY            │
         │  Execute Query   │      │  Return 403      │
         └──────────────────┘      └──────────────────┘
```

## 📊 Data Flow Example: Creating an Item

```
1. USER FILLS FORM
   ┌─────────────────┐
   │ Title: iPhone   │
   │ Category: Elec. │
   │ Status: Lost    │
   │ [Image Selected]│
   │   [Submit]      │
   └─────────────────┘
          │
          ▼
2. SCREEN VALIDATES
   ┌─────────────────┐
   │ Check required  │
   │ fields filled   │
   └─────────────────┘
          │
          ▼
3. CALL PROVIDER
   itemProvider.createItem(
     title: "iPhone",
     category: "Electronics",
     status: "lost",
     imageFile: file
   )
          │
          ▼
4. UPLOAD IMAGE
   ┌─────────────────┐
   │ Supabase Storage│
   │ item-images/    │
   │ 123456.jpg      │
   └─────────────────┘
          │
          ▼ Returns URL
5. INSERT TO DATABASE
   ┌─────────────────┐
   │ INSERT INTO     │
   │ items (...)     │
   │ VALUES (...)    │
   └─────────────────┘
          │
          ▼
6. REFRESH DATA
   ┌─────────────────┐
   │ fetchItems()    │
   │ notifyListeners │
   └─────────────────┘
          │
          ▼
7. UI UPDATES
   ┌─────────────────┐
   │ Show success    │
   │ Navigate back   │
   │ List refreshed  │
   └─────────────────┘
```

## 🎨 Color Scheme

```
Primary Color:    #2196F3 (Blue)
Primary Dark:     #1976D2 (Dark Blue)
Success:          #4CAF50 (Green)
Error:            #F44336 (Red)
Warning:          #FF9800 (Orange)
Background:       #F5F5F5 (Light Gray)
Card:             #FFFFFF (White)
Text Primary:     #212121 (Dark Gray)
Text Secondary:   #757575 (Gray)
```

## 📱 Responsive Design

```
┌─────────────────────────────────────┐
│  Small Phones (< 360dp width)       │
│  - Single column layout             │
│  - Compact cards                    │
│  - Bottom navigation                │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  Medium Phones (360-600dp)          │
│  - Standard layout                  │
│  - Full-size cards                  │
│  - Tabs + FAB                       │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  Tablets (> 600dp)                  │
│  - Two-column layout (future)       │
│  - Side navigation (future)         │
│  - Master-detail view (future)      │
└─────────────────────────────────────┘
```

---

This visual guide provides a clear overview of the app's structure, flow, and architecture for easy understanding and reference.
