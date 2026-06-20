# 🔐 Alarm System Demo App (Flutter)

A Flutter application built as part of a technical assessment.  
The app demonstrates authentication, API integration, and real-time state updates for an alarm monitoring system.

---

## 📱 Overview

This application allows users to:

- Log in using provided credentials
- Authenticate via an external OAuth-based service
- Retrieve and store an access token securely
- Connect to an alarm system service
- View the current alarm status
- Trigger a state change (arm the system)
- Refresh and reflect real-time status updates

---

## 🧭 App Flow

### 1. Login Screen
- User enters credentials
- App authenticates with an external service
- A secure access token is returned and stored for session use

---

### 2. Alarm Status Screen
- App initializes a connection to the alarm system
- Retrieves the current system status
- Displays whether the alarm is active or inactive
- Allows the user to refresh status or trigger a state change

---

## 🔐 Authentication

- The app uses an OAuth-based authentication flow
- After successful login, an access token is issued
- This token is required for all subsequent API interactions
- Token handling is managed within app state (Provider)

---

## 📡 Alarm System Features

The app interacts with a remote alarm system to:

- Initialize a session/connection
- Retrieve current alarm state
- Trigger a state change (arm action)
- Re-fetch status to ensure UI consistency

---

## 🛠️ Tech Stack

- Flutter
- Dart
- Provider (State Management)
- HTTP Client
- REST API Integration
- OAuth 2.0 Authentication Flow

---

## 🧠 Key Concepts Demonstrated

- Secure authentication flow handling
- Token-based API communication
- State management across screens
- Asynchronous programming (async/await)
- UI updates based on API responses
- Separation of concerns (UI vs services layer)

---

## 📂 Project Structure
lib/
 ├── main.dart
 ├── screens/
 │     ├── login_screen.dart
 │     └── status_screen.dart
 ├── services/
 │     └── api_service.dart
 ├── providers/
 │     └── login_provider.dart


 ## 🚀 Features

- Clean login flow with authentication handling
- Secure token storage in app state
- Alarm status monitoring screen
- Manual refresh of system state
- Ability to trigger alarm state changes
- Real-time UI updates after API actions

---

## 📌 Notes

- All sensitive configuration details are abstracted for security
- API communication is handled through a dedicated service layer
- State updates are managed using Provider
- UI reflects live system state after every action

---
