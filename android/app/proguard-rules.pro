# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Keep ML Kit Text Recognition classes
# These classes are referenced by the plugin but may not be directly used
-keep class com.google.mlkit.vision.text.** { *; }

# Keep specific classes for other languages (referenced by plugin)
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions { *; }
-keep class com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions$Builder { *; }

-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.DevanagariTextRecognizerOptions { *; }
-keep class com.google.mlkit.vision.text.devanagari.DevanagariTextRecognizerOptions$Builder { *; }

-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions { *; }
-keep class com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions$Builder { *; }

-keep class com.google.mlkit.vision.text.korean.** { *; }
-keep class com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions { *; }
-keep class com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions$Builder { *; }

# Keep ML Kit Commons classes
-keep class com.google.mlkit.common.** { *; }

# Keep Flutter plugin classes
-keep class com.google_mlkit_text_recognition.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep annotation default values
-keepattributes AnnotationDefault

# Keep line numbers for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
