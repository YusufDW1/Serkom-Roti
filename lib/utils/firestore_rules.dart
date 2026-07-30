// lib/utils/firestore_rules.dart
//
// Firestore Security Rules for Roti Saku
// Copy these rules to Firebase Console → Firestore → Rules tab

/*
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection - users can only read/write their own document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Orders collection
    match /orders/{orderId} {
      // Authenticated users can create orders
      allow create: if request.auth != null;
      
      // Users can read orders where they are the customer
      // Admins can read all orders
      allow read: if request.auth != null && (
        resource.data.customerId == request.auth.uid ||
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin'
      );
      
      // Only customer can update status to 'cancelled' (only if pending)
      // Admins can update any status
      allow update: if request.auth != null && (
        // Customer cancelling their own pending order
        (resource.data.customerId == request.auth.uid &&
         resource.data.status == 'pending' &&
         request.resource.data.status == 'cancelled') ||
        // Admin updating status
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin'
      );
    }
  }
}
*/
