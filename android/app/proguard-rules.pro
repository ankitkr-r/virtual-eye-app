# Protect TensorFlow Lite from R8 code stripping
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**

# Protect the GPU delegate
-keep class org.tensorflow.lite.gpu.** { *; }
-dontwarn org.tensorflow.lite.gpu.**

# ADD THESE - ML Kit object detection
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**
-keep class com.google.android.gms.internal.mlkit_vision_common.** { *; }

# ADD THESE - Camera
-keep class androidx.camera.** { *; }
-dontwarn androidx.camera.**

# ADD THESE - Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
-keep class io.flutter.plugins.** { *; }

# ADD THIS - keep native methods 16KB aligned
-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}