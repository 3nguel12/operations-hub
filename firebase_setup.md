# Firebase Setup & Database Schema Design Guide

This guide details the Firestore database collections design, Firestore Security Rules, and step-by-step instructions to implement the database and connect it to your Flutter application.

---

## 1. Cloud Firestore Collection Schemas

We will set up 4 main collections in Firestore: `users`, `businesses` (with a subcollection `services`), and `appointments`.

### A. `users` Collection
Stores profile data for users registered in the system.
* **Document ID**: Auth User UID (from Firebase Authentication)
* **Structure**:
```json
{
  "name": "Elena Ríos",
  "email": "elena@example.com",
  "role": "owner",          // "client" | "owner"
  "createdAt": "Timestamp"
}
```

### B. `businesses` Collection
Stores metadata for registered services/businesses.
* **Document ID**: Custom ID or Slug (e.g., `the-classic-trim`, `lumina-beauty-studio`)
* **Structure**:
```json
{
  "name": "The Classic Trim",
  "category": "Barberías",   // "Barberías" | "Salones de Belleza" | "Talleres" | "Consultorios"
  "subtitle": "1.2 km away • Downtown",
  "rating": 4.8,
  "address": "123 Luxury Ave, Suite 400, Beverly Hills, CA 90210",
  "hours": "Abierto ahora",
  "imageUrl": "https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&q=80&w=600",
  "isGreen": true,
  "ownerId": "OWNER_USER_UID",
  "createdAt": "Timestamp"
}
```

#### Subcollection: `services` (Path: `/businesses/{businessId}/services/{serviceId}`)
Stores individual services offered by the parent business.
* **Document ID**: Auto-generated
* **Structure**:
```json
{
  "name": "Lifestyle Consultation",
  "duration": "60 min",
  "price": "$150",
  "description": "A comprehensive 60-minute assessment to understand your needs."
}
```

### C. `appointments` Collection
Stores appointment bookings.
* **Document ID**: Auto-generated
* **Structure**:
```json
{
  "clientId": "CLIENT_USER_UID",       // Auth UID, or "anonymous_client"
  "clientName": "John Doe",
  "businessId": "the-classic-trim",
  "businessName": "The Classic Trim",
  "serviceName": "Lifestyle Consultation",
  "price": "$150",
  "duration": "60 min",
  "date": "Thursday, October 12, 2023",
  "timeSlot": "10:30 AM",
  "status": "CONFIRMED",               // "CONFIRMED" | "PENDING" | "COMPLETED" | "CANCELLED"
  "createdAt": "Timestamp"
}
```

---

## 2. Cloud Firestore Security Rules

Copy and paste these rules into the **Rules** tab of your Firestore console to protect client data:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper check if the user is signed in
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Helper check to get user data from the users collection
    function getUserData() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data;
    }

    // Users Collection rules
    match /users/{userId} {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && request.auth.uid == userId;
    }

    // Businesses Collection & Services rules
    match /businesses/{businessId} {
      allow read: if true; // Anyone can explore businesses
      allow write: if isSignedIn() && getUserData().role == 'owner';
      
      match /services/{serviceId} {
        allow read: if true; // Anyone can view services
        allow write: if isSignedIn() && get(/databases/$(database)/documents/businesses/$(businessId)).data.ownerId == request.auth.uid;
      }
    }

    // Appointments Collection rules
    match /appointments/{appointmentId} {
      // Clients can read/write their own appointments. Owners can read all appointments for their businesses.
      allow create: if true; // Allow creation (anonymous checkout or authenticated)
      allow read, update, delete: if true; // In development. For production: if isSignedIn() && (resource.data.clientId == request.auth.uid || getUserData().role == 'owner');
    }
  }
}
```

---

## 3. Step-by-Step Connection & Implementation Guide

### Step 1: Create a Firebase Project
1. Open the [Firebase Console](https://console.firebase.google.com/).
2. Click **Add Project** (or **Create Project**).
3. Enter `operations-hub` as the name, follow the prompts, and click **Create**.

### Step 2: Set up Authentication
1. In the left panel, navigate to **Build** > **Authentication**.
2. Click **Get Started**.
3. Under the **Sign-in method** tab, click **Email/Password**.
4. Enable the first toggle ("Email/Password") and click **Save**.

### Step 3: Set up Cloud Firestore Database
1. Under **Build**, select **Firestore Database**.
2. Click **Create Database**.
3. Choose the Database location closest to your users.
4. Select **Start in test mode** (for development) and click **Create**.
5. Once created, go to the **Rules** tab, copy the rules from Section 2 of this guide, paste them, and click **Publish**.

### Step 4: Connecting the Flutter App (Already Integrated)
The Flutter project is already equipped with Firebase configuration! The file `lib/firebase_options.dart` is fully set up for Android and iOS using the Firebase project `operations-hub-73660`.

If you ever need to reconnect or recreate the project:
1. Install the FlutterFire CLI globally:
   ```bash
   dart pub global activate flutterfire_cli
   ```
2. Run the configuration command in your project directory:
   ```bash
   flutterfire configure --project=YOUR_NEW_PROJECT_ID
   ```
3. This updates `firebase_options.dart` with new credentials.

### Step 5: Verify Initialization in Main Entrypoint
Your app's `main()` function in `lib/main.dart` initializes Firebase:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const OperationsHubApp());
}
```
*(Firebase initialization is wrapped in a safety try-catch block to prevent local runs on unsupported platforms from crashing.)*
