![Crete Banner](banner.jpeg)

# Crete - Decentralized DAO Community App (Flutter Frontend)

> The first decentralized community app built specifically for DAOs

[![Follow us on X](https://img.shields.io/badge/Follow%20us%20on%20X-@CreteDAO-1DA1F2?style=for-the-badge&logo=x&logoColor=white)](https://x.com/CreteDAO)

## 🎯 Project Scope & Responsibilities

### Frontend (Flutter) Responsibilities

This Flutter app handles:

- **User Interface & Experience**: All UI/UX for mobile and web
- **Wallet Integration**: Solana wallet connection and transaction signing
- **State Management**: App state, user sessions, and local caching
- **Real-time Updates**: WebSocket connections for live data
- **Local Storage**: User preferences, cache, and offline data
- **Push Notifications**: Local notification handling and display
- **Deep Linking**: App navigation from external links
- **Blink Integration**: Solana Actions (Blinks) for instant transactions

### Backend & Smart Contract Responsibilities

**What the backend handles** (not in this Flutter project):

- User authentication and session management
- DAO data storage and management
- Chat message storage and routing
- Proposal creation and vote counting
- Push notification delivery
- File uploads and media storage
- Analytics and logging
- Rate limiting and security

**What smart contracts handle**:

- On-chain governance (proposals, voting)
- Token-based permissions
- DAO treasury management
- Member role assignments

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    FLUTTER APP                          │
├─────────────────────────────────────────────────────────┤
│  Presentation Layer (UI/UX)                            │
│  • Pages, Widgets, Animations                          │
│  • State Management (Cubit/Bloc)                       │
│  • Navigation & Routing                                │
├─────────────────────────────────────────────────────────┤
│  Domain Layer (Business Logic)                         │
│  • Entities, Use Cases                                 │
│  • Repository Interfaces                               │
├─────────────────────────────────────────────────────────┤
│  Data Layer (Data Management)                          │
│  • Repository Implementations                          │
│  • Remote Data Sources (API calls)                     │
│  • Local Data Sources (SharedPreferences)              │
│  • Models & Serialization                              │
└─────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────┐
│              EXTERNAL SERVICES                          │
├─────────────────────────────────────────────────────────┤
│  • Backend API (REST/GraphQL)                          │
│  • WebSocket for real-time chat                        │
│  • Solana RPC for blockchain data                      │
│  • Wallet providers (Phantom, Solflare, etc.)         │
│  • Blinks API for instant transactions                 │
│  • Push notification services                          │
└─────────────────────────────────────────────────────────┘
```

## 📱 Core Features

### 1. **Onboarding & Authentication**

- [ ] Splash screen with app branding
- [ ] Wallet selection (Phantom, Solflare, Backpack, WalletConnect)
- [ ] Guest mode (view-only access)
- [ ] Discord import flow (OAuth + role mapping)
- [ ] Profile setup (display name, avatar)
- [ ] Permissions requests (notifications, etc.)

### 2. **Wallet Integration**

- [ ] Multi-wallet support (Phantom, Solflare, Backpack)
- [ ] WalletConnect for other wallets
- [ ] Transaction signing and confirmation
- [ ] Balance display and token holdings
- [ ] Wallet connection status management
- [ ] Blinks integration for instant transactions

### 3. **DAO Management**

- [ ] DAO discovery and search
- [ ] DAO detail pages with member count, description
- [ ] Join/leave DAO functionality
- [ ] Member list and role display
- [ ] DAO settings and preferences
- [ ] Role-based UI permissions

### 4. **Real-time Chat**

- [ ] Chat room list grouped by DAO
- [ ] Real-time messaging via WebSocket
- [ ] Message reactions and replies
- [ ] User mentions and notifications
- [ ] Message history and pagination
- [ ] Typing indicators
- [ ] Image sharing (upload to backend)

### 5. **Governance System**

- [ ] Proposal list with filtering (Active, Ended, My Votes)
- [ ] Proposal creation form with templates
- [ ] Voting interface with wallet signing
- [ ] Real-time vote count updates
- [ ] Proposal details and discussion
- [ ] Voting power calculation display
- [ ] Proposal sharing and deep links

### 6. **Navigation & UX**

- [ ] Bottom navigation (Home, DAOs, Chat, Governance, Profile)
- [ ] Home dashboard with recent activity
- [ ] Search functionality across DAOs and proposals
- [ ] Pull-to-refresh for data updates
- [ ] Infinite scrolling for lists
- [ ] Smooth animations and transitions

### 7. **Notifications**

- [ ] Push notification setup and permissions
- [ ] Local notification display
- [ ] Notification preferences per DAO
- [ ] In-app notification center
- [ ] Deep link handling from notifications

### 8. **User Profile & Settings**

- [ ] Profile editing (display name, avatar)
- [ ] Wallet management and switching
- [ ] App theme selection (light/dark/system)
- [ ] Notification preferences
- [ ] Language selection
- [ ] Privacy settings

### 9. **Deep Linking**

- [ ] DAO invitation links
- [ ] Proposal sharing links
- [ ] Chat room direct links
- [ ] Profile links
- [ ] Universal link support

### 10. **Offline & Caching**

- [ ] Offline DAO list viewing
- [ ] Cached message history
- [ ] Optimistic UI updates
- [ ] Queue actions for when online
- [ ] Smart cache invalidation

## 🔧 Technical Stack

### **Core Framework**

- **Flutter**: Cross-platform mobile and web development
- **Dart**: Programming language

### **State Management**

- **flutter_bloc**: Predictable state management
- **equatable**: Value equality for state objects

### **Network & Data**

- **dio**: HTTP client for API calls
- **retrofit**: Type-safe API client generation
- **shared_preferences**: Simple local storage for user preferences
- **connectivity_plus**: Network connectivity checking
- **web_socket_channel**: Real-time WebSocket connections

### **Wallet & Blockchain**

- **solana**: Solana blockchain integration
- **solana_mobile_client**: Mobile-specific Solana features

### **UI & UX**

- **flutter_svg**: SVG image support
- **cached_network_image**: Image caching and optimization
- **shimmer**: Loading animations and placeholders
- **flutter_animate**: Advanced animations and transitions

### **Utilities**

- **get_it**: Dependency injection container
- **injectable**: DI code generation
- **json_annotation**: JSON serialization annotations
- **uuid**: Unique ID generation
- **intl**: Internationalization support

### **Platform Features**

- **firebase_messaging**: Push notifications
- **app_links**: Deep link handling
- **permission_handler**: Device permissions management
- **local_auth**: Biometric authentication
- **package_info_plus**: App information and versioning

## 🚀 Quick Start

### **Prerequisites**

- Flutter 3.8.1 or higher
- Dart SDK
- Firebase project (for push notifications)
- Solana devnet/mainnet access

### **Setup Steps**

1. **Clone and install dependencies**:

   ```bash
   flutter pub get
   ```

2. **Generate code**:

   ```bash
   flutter packages pub run build_runner build
   ```

3. **Environment setup**:

   ```bash
   cp env.example .env.dev
   cp env.example .env.prod
   # Edit .env files with your API endpoints and keys
   ```

4. **Firebase setup**:

   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Configure Firebase project for push notifications

5. **Run the app**:
   ```bash
   flutter run --flavor dev --dart-define-from-file=.env.dev
   ```

### **Code Generation**

When you modify models or add new injectable classes:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📋 Project Setup

For complete project setup and foundation tasks before UI development, see **[SETUP_GUIDE.md](SETUP_GUIDE.md)**.

The setup guide includes:

- Environment configuration and build flavors
- Firebase and Solana integration
- App icons and branding setup
- Security and performance configuration
- Testing infrastructure setup
- Production readiness checklist

## 🚀 User Journey

### **First-Time User**

1. **Landing**: See 3 options (Connect Wallet, Browse as Guest, Import from Discord)
2. **Wallet Connection**: Select and connect Solana wallet
3. **Profile Setup**: Choose display name and avatar (optional)
4. **Permissions**: Grant notification and other permissions
5. **Welcome Tour**: Quick 3-screen tutorial
6. **Home Dashboard**: View recent activity and discover DAOs

### **Regular User Flow**

1. **Home**: Check recent activity, notifications, quick actions
2. **Discover**: Browse and join new DAOs
3. **Chat**: Participate in DAO conversations
4. **Governance**: Vote on proposals and create new ones
5. **Profile**: Manage settings and wallet connections

### **DAO Member Journey**

1. **Join DAO**: Through invitation link or discovery
2. **Role Assignment**: Automatic based on token holdings
3. **Chat Participation**: Join conversations, react to messages
4. **Governance**: Create proposals, vote, discuss
5. **Community Building**: Invite others, moderate discussions

## 📊 Data Flow

### **User Data**

- **Storage**: Backend database
- **Frontend**: Cached user profile, preferences in SharedPreferences
- **Updates**: Real-time via WebSocket for profile changes

### **DAO Data**

- **Storage**: Backend database + on-chain verification
- **Frontend**: Cached DAO list, member counts, recent activity
- **Updates**: Periodic refresh + real-time for member changes

### **Chat Data**

- **Storage**: Backend message storage
- **Frontend**: Recent message cache, optimistic sending
- **Updates**: Real-time via WebSocket

### **Governance Data**

- **Storage**: On-chain proposals + backend metadata
- **Frontend**: Cached proposal list, vote status
- **Updates**: Real-time vote count updates via WebSocket

## 🔐 Security Considerations

### **Frontend Security**

- **Wallet Security**: Never store private keys, only connect to trusted wallets
- **API Security**: Secure token storage, request signing
- **Deep Link Validation**: Validate all incoming deep links
- **Input Validation**: Client-side validation for better UX
- **Biometric Auth**: Optional biometric protection for sensitive actions

### **Privacy**

- **Local Data**: Minimal sensitive data storage
- **Analytics**: Privacy-focused analytics (no PII)
- **Permissions**: Granular permission requests

## 🎨 Design System

### **Theme**

- **Colors**: Solana-inspired purple primary, clean secondary colors
- **Typography**: Inter font family, clear hierarchy
- **Spacing**: 8dp grid system for consistency
- **Animations**: Smooth, purposeful animations (300ms standard)

### **Components**

- **Cards**: DAO cards, proposal cards, message bubbles
- **Buttons**: Primary, secondary, icon buttons
- **Forms**: Input fields, dropdowns, validation
- **Lists**: Infinite scroll, pull-to-refresh
- **Modals**: Confirmation dialogs, voting interfaces

## 🔄 Real-time Features

### **WebSocket Connections**

- **Chat Messages**: Instant message delivery
- **Vote Updates**: Live vote count changes
- **Member Status**: Online/offline indicators
- **Notifications**: Real-time notification delivery

### **Optimistic Updates**

- **Message Sending**: Show message immediately, handle failures
- **Vote Casting**: Show vote immediately, confirm on-chain
- **DAO Joining**: Immediate UI update, backend confirmation

## 📈 Performance Goals

### **Load Times**

- **App Launch**: < 2 seconds to home screen
- **DAO List**: < 1 second to load cached data
- **Chat Room**: < 500ms to load recent messages
- **Proposal Voting**: < 3 seconds including wallet confirmation

### **Responsiveness**

- **60 FPS**: Smooth animations and scrolling
- **Instant Feedback**: Immediate response to user interactions
- **Progressive Loading**: Show content as it loads

## 🧪 Testing Strategy

### **Unit Tests**

- Business logic in use cases
- Utility functions and extensions
- State management (Cubits)

### **Widget Tests**

- Individual component behavior
- Form validation
- Navigation flows

### **Integration Tests**

- Complete user journeys
- Wallet connection flows
- API integration

## Out of Scope

### **Removed Dependencies** (Frontend Focus)

- **Hive**: Replaced with `shared_preferences` for simple local storage (no complex local database needed)
- **Matrix SDK**: Removed - chat functionality will use WebSocket connection to backend instead
- **SQLite/Floor**: Not needed - backend handles data persistence
- **Firebase Auth**: Authentication handled by backend API
- **Local Database**: All complex data stored in backend, only simple preferences cached locally

### **Backend Functionality** (Handled by backend team)

- User authentication servers
- Database management
- File storage and CDN
- Email/SMS delivery
- Analytics data collection
- Rate limiting and abuse prevention

### **Smart Contract Development** (Handled by blockchain team)

- Governance contract logic
- Token distribution
- Treasury management
- On-chain voting mechanisms

### **Infrastructure** (Handled by DevOps)

- Server deployment
- Database hosting
- CDN configuration
- Monitoring and logging
- Backup strategies

## 📝 Notes

### **Scope Clarification**

This Flutter project has been architected with a **clear separation of concerns**:

✅ **Frontend Responsibilities** (This Flutter app):

- Complete UI/UX for mobile and web platforms
- Solana wallet integration and transaction signing
- Real-time WebSocket connections for chat and updates
- Local caching with SharedPreferences (no complex local database)
- Push notification display and local notification handling
- Deep linking and navigation management
- Blinks integration for instant Solana transactions

❌ **Not in Scope** (Handled by other teams):

- **Backend services**: Authentication, database, file storage, analytics
- **Smart contracts**: On-chain governance, voting, treasury management
- **Infrastructure**: Server deployment, monitoring, CDN, backups

### **Architecture Decisions**

- **No Hive/SQLite**: Simple `shared_preferences` for user settings only
- **No Matrix SDK**: WebSocket connection to custom backend for chat
- **No local authentication**: Backend handles auth, frontend manages session
- **Clean Architecture**: Clear separation between presentation, domain, and data layers

### **Integration Points**

- **Backend API**: Will be provided by backend team with OpenAPI specification
- **WebSocket Events**: Real-time event schema will be defined by backend team
- **Blinks Integration**: Solana Actions endpoints will be provided
- **Push Notifications**: Backend will handle notification sending, frontend handles display
- **Smart Contract ABI**: Will be provided by blockchain team for governance interactions

This Flutter app focuses purely on providing an excellent user experience while connecting to robust backend services and smart contracts for data and business logic.
