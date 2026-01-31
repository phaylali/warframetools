# Android Release Preparation Guide

This guide outlines the steps to securely prepare WarframeTools for release on the Google Play Store.

## 1. 🔐 Secure Signing Keys

**IMPORTANT**: Never commit your `.jks` or `key.properties` files to version control (GitHub). They are already added to `.gitignore`.

### Generate a keystore
If you haven't already, generate an upload key:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### Create `key.properties`
Create a file at `android/key.properties` with the following content:
```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=<path-to-your-keystore-file>
```

## 2. 🏗️ Update Build Configuration

To use the `key.properties` file, update your `android/app/build.gradle.kts`:

```kotlin
// Add this near the top of the 'android' block
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ...
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            // Optional: Add obfuscation
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}
```

## 3. 📦 Build the App Bundle

Google Play Store requires the App Bundle (`.aab`) format:

```bash
flutter build appbundle --release
```

The output file will be located at:
`build/app/outputs/bundle/release/app-release.aab`

## 4. ✅ Pre-launch Checklist
- [ ] Version name and code are updated in `pubspec.yaml`.
- [ ] App icon is correctly generated (done).
- [ ] Privacy Policy is uploaded to your website/GitHub and linked in Play Console.
- [ ] All debug prints and logs are removed or disabled.
