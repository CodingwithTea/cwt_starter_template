# cwt_starter_template

Thank you for your support ❤️❤️

## Getting Started

This project is a starting point for a Flutter application.
A few resources to get you started if this is your first Flutter project:

## Tutorials
- [DESIGN PLAYLIST](https://www.youtube.com/playlist?list=PL5jb9EteFAODpfNJu8U2CMqKFp4NaXlto)
- [FIREBASE PLAYLIST](https://www.youtube.com/playlist?list=PL5jb9EteFAOC9V6ZHAIg3ycLtjURdVxUH)
- [Firebase setup](https://www.youtube.com/watch?v=fxDusoMcWj8)




## ERROR
1. If you are facing [The current Flutter SDK version is 3.10.6. Because login_flutter_app depends on get >=4.6.6 <5.0.0-beta.1 which requires Flutter SDK version >=3.13.0, version solving failed.].
   [Solution]: run flutter upgrade to upgrade your flutter sdk to the latest. Make sure to have an active internet connection.


## Docs
     1. Show Splash Screen till data loads & when loaded call FlutterNativeSplash.remove(); 
        In this case I'm removing it inside AuthenticationRepository() -> onReady() method.
     2. Before running App - Initialize Firebase and after initialization, Call Authentication Repository so that It can check which screen to show.
     3. Solves the issues of Get.lazyPut and Get.Put() by defining all Controllers in InitialBinding
     4. Screen Transitions: Use these 2 properties in GetMaterialApp
            - defaultTransition: Transition.leftToRightWithFade,
            - transitionDuration: const Duration(milliseconds: 500),
     5. HOME SCREEN:
            - Show Progress Indicator OR SPLASH SCREEN until Screen Loads all its data from cloud.
            - Let the AuthenticationRepository decide which screen to appear as first.
     6. Authentication Repository:
            - Used for user authentication and screen redirects.
            - Called from main.dart on app launch.
            - onReady() sets firebaseUser state, removes Splash Screen, and redirects to relevant screen.
            - To use in other classes: [final auth = AuthenticationRepository.instance;]

### Firebase Configuration

* Initial Setup

   1. Install Firebase CLI
   2. Connect project:
      1. Initialize Firebase in your local project
         - Install the Firebase CLI (if you haven’t already):
           ```shell
             npm install -g firebase-tools
           ```
         - Log in and select your project:
           ```shell
             firebase login
           ```
           ```shell
             firebase use --add
           ```
         - In your Flutter Project root, run:
         - NOTE: Make sure to remove the already attached project from .firebaserc file.
         - Remove this line if exist
         - ```shell
            "default": "codingwitht-c6d0f"
           ```
         - After that run
           ```shell
             flutterfire configure
           ```
         - Choose the Firebase project, platforms (iOS/Android/Web),
         - and generate the firebase_options.dart file.


* Services Activation

1. Enable in Firebase Console:
   * Authentication (Email/Password)
   * Firestore Database (Test mode)
   * Storage

* SHA Keys (Android)
# Mac/Linux
  ```bash 
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
  ```

# Windows
  ```bash
   keytool -list -v -keystore "C:\Users\YourPC\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
  ```
Add output SHA1/SHA256 to Firebase Project Settings > Your App


### ☁️ Storage Configuration

* CORS Setup
   1. Open Google Cloud Console (https://console.cloud.google.com/)
   2. Activate Cloud Shell (top-right) and run:
      ```shell
       echo '[{"origin":["*"],"method":["GET","HEAD"],"responseHeader":["Content-Type"],"maxAgeSeconds":3600}]' > cors-config.json
      ```
   3. Replace ~~YOUR_BUCKET_NAME~~ with your actual bucket which is in the
      Firebase Console -> Storage -> Copy the gs://... bucket name and replace with the below command.
      ```shell
       gsutil cors set cors-config.json gs://YOUR_BUCKET_NAME
      ```
      - Run this command in the Google shell terminal and you are done.

   4. To check if everything worked as expected, you can get the cors-settings of a bucket with the
      following command:

      ```shell
       gsutil cors get gs://YOUR_BUCKET_NAME
      ```


### ☁️ Cloud Functions Deployment
- Initialize Cloud Functions Directory
- From your project root, run:
  ```shell
    firebase init functions
  ```
- NOTE: Select JavaScript, enable ESLint, & do not modify `index.js`.

- Prerequisites:
- Node.js v18.16.0+
- npm v9.5.1+

1. Initialize Functions
     ```bash
     cd functions
     ```
     ```bash
     npm install
     ```
2. Deploy Functions
   ```shell
   firebase deploy --only functions
   ```

##### Common Issues & Solutions:
-  **Issue**	                **Solution**
-   403 PERMISSION_DENIED:	Add Cloud Functions Admin role in IAM
-   Dependency Error:  	    Run rm -rf node_modules && npm install
-   Deployment Timeout:	    Increase timeout in package.json: "engines": {"node": "18"}
-   Region Mismatch:	    Specify region in function declaration: functions.region('us-central1')

### 🛠 Support
For assistance contact our technical team:

    📧 Email: support@codingwitht.com
    🌐 Website: https://codingwitht.com
    📞 WhatsApp: +44-7456-285429



### 📄 License
MIT © Coding with T

## ⚖️ Legal Compliance
All users except Enterprise users must display this notice prominently in application:

* Copyright (C) 2025 Coding with T.
* Licensed under Professional Tier (PID: #{your_license_id OR your_order_id}).
* Unauthorized use violates EULA (End User License Agreement) and may result in legal action.