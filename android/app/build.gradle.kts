import java.util.Properties
import java.io.FileInputStream


plugins {   
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.marketrix.puntossmartcomercio"
    // Plugins y androidx requieren compileSdk >= 36 (camera_android_camerax, activity-ktx, core-ktx, etc.)
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // Suprimir advertencias de compilación de Java para dependencias externas (ML Kit)
    // Esto suprime los warnings de "unchecked operations" que vienen de google_mlkit_commons
    tasks.withType<JavaCompile>().configureEach {
        options.compilerArgs.addAll(listOf(
            "-Xlint:-unchecked",
            "-Xlint:-deprecation"
        ))
        // También suprimir warnings en modo verbose
        options.isWarnings = false
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.marketrix.puntossmartcomercio"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // ML Kit requiere minSdk 21 según documentación oficial
        // El ejemplo usa 24, pero 21 es suficiente para text recognition
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        getByName("debug") {
            // Configuración específica para modo debug
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false
        }
        getByName("release") {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
            // Configurar ProGuard/R8 rules para ML Kit
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    
    // Configuración para ML Kit: no comprimir modelos si los usáramos en el futuro
    // No es necesario para text recognition, pero es buena práctica tenerlo
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Agregar dependencias de ML Kit para otros idiomas
    // Aunque solo usemos latino, el plugin referencia estas clases
    // y R8 las necesita en el classpath para compilar en release
    implementation("com.google.mlkit:text-recognition-chinese:16.0.0")
    implementation("com.google.mlkit:text-recognition-devanagari:16.0.0")
    implementation("com.google.mlkit:text-recognition-japanese:16.0.0")
    implementation("com.google.mlkit:text-recognition-korean:16.0.0")
}
