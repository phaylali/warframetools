# Flutter ProGuard Rules

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Drift/SQLite Rules
-keep class net.sqlcipher.** { *; }
-keep class org.sqlite.** { *; }

# PocketBase/JSON Rules
-keep class com.google.gson.** { *; }
-keepnames class * implements java.io.Serializable

# Avoid shrinking data models
-keep class com.omniversify.warframe.warframe_tools.models.** { *; }
