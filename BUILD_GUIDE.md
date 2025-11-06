# Script de Verificación y Compilación - Movie App

## ✅ Checklist de Configuración

Antes de ejecutar la aplicación, verifica que hayas completado estos pasos:

### 1. Instalación de Flutter
- [ ] Flutter SDK instalado
- [ ] Flutter agregado al PATH
- [ ] Ejecutar `flutter doctor` y resolver problemas

### 2. Configuración de la API
- [ ] Cuenta creada en TMDB
- [ ] API Key obtenida
- [ ] API Key configurada en `lib/services/tmdb_service.dart`

### 3. Dependencias del Proyecto
- [ ] Ejecutar `flutter pub get`
- [ ] Todas las dependencias instaladas correctamente

### 4. Configuración de Plataformas

#### Android
- [ ] Android Studio instalado
- [ ] SDK de Android configurado
- [ ] Emulador o dispositivo físico conectado
- [ ] Permisos de internet en AndroidManifest.xml

#### iOS (solo macOS)
- [ ] Xcode instalado
- [ ] CocoaPods instalado
- [ ] Ejecutar `pod install` en carpeta ios/
- [ ] Simulador o dispositivo físico conectado

---

## 🚀 Comandos Útiles

### Verificar Configuración de Flutter
```bash
flutter doctor -v
```

### Instalar Dependencias
```bash
cd movie_app
flutter pub get
```

### Ver Dispositivos Disponibles
```bash
flutter devices
```

### Limpiar Build (si hay errores)
```bash
flutter clean
flutter pub get
```

### Ejecutar en Modo Debug
```bash
# Android
flutter run

# iOS (solo macOS)
flutter run

# Dispositivo específico
flutter run -d <device_id>

# Web
flutter run -d chrome
```

### Compilar Release

#### Android APK
```bash
flutter build apk --release
```
El APK estará en: `build/app/outputs/flutter-apk/app-release.apk`

#### Android App Bundle (para Play Store)
```bash
flutter build appbundle --release
```
El bundle estará en: `build/app/outputs/bundle/release/app-release.aab`

#### iOS (solo macOS)
```bash
flutter build ios --release
```

---

## 🔍 Diagnóstico de Problemas

### Problema: "API Key inválida"

**Síntoma**: Las películas no se cargan, error 401

**Solución**:
1. Abre `lib/services/tmdb_service.dart`
2. Verifica que la API Key esté correctamente copiada
3. No debe tener espacios al inicio o final
4. Debe tener exactamente 32 caracteres
5. Ejemplo: `static const String apiKey = 'a1b2c3d4...';`

### Problema: No se cargan imágenes

**Síntoma**: Los pósters aparecen en gris o con icono de error

**Solución**:
1. Verifica conexión a internet
2. En Android: Verifica permisos en AndroidManifest.xml
3. En iOS: Verifica Info.plist
4. Ejecuta `flutter clean` y `flutter pub get`

### Problema: Error de compilación

**Síntoma**: Errores al ejecutar `flutter run`

**Solución**:
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

### Problema: Los trailers no se abren

**Síntoma**: Tap en trailer no hace nada

**Solución**:
1. Verifica que tengas YouTube instalado
2. En Android: Agrega queries en AndroidManifest.xml
3. En iOS: Configura LSApplicationQueriesSchemes

---

## 📱 Configuración por Plataforma

### Android

#### AndroidManifest.xml
Ubicación: `android/app/src/main/AndroidManifest.xml`

Debe incluir:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

<queries>
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="https" />
    </intent>
</queries>
```

#### build.gradle
Ubicación: `android/app/build.gradle`

Verifica:
```gradle
minSdkVersion 21
targetSdkVersion 33
compileSdkVersion 33
```

### iOS

#### Info.plist
Ubicación: `ios/Runner/Info.plist`

Debe incluir:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>https</string>
    <string>http</string>
</array>
```

---

## 🧪 Testing

### Ejecutar Tests (si existen)
```bash
flutter test
```

### Analizar Código
```bash
flutter analyze
```

### Formatear Código
```bash
flutter format .
```

---

## 📊 Métricas de Rendimiento

### Tamaño del APK
```bash
flutter build apk --release
flutter build apk --analyze-size
```

### Perfil de Rendimiento
```bash
flutter run --profile
```

---

## 🔧 Configuración Avanzada

### Cambiar Nombre de la App

**Android**: `android/app/src/main/AndroidManifest.xml`
```xml
<application android:label="Tu Nombre">
```

**iOS**: `ios/Runner/Info.plist`
```xml
<key>CFBundleName</key>
<string>Tu Nombre</string>
```

### Cambiar Icono de la App

1. Usa el paquete `flutter_launcher_icons`
2. Crea iconos en diferentes resoluciones
3. Ejecuta: `flutter pub run flutter_launcher_icons:main`

### Cambiar Package Name

**Android**: 
1. `android/app/build.gradle` - applicationId
2. `android/app/src/main/AndroidManifest.xml` - package

**iOS**:
1. Abre Xcode
2. Cambia Bundle Identifier

---

## 📝 Logs y Debug

### Ver Logs en Consola
```bash
flutter run --verbose
```

### Logs de Android
```bash
adb logcat
```

### Logs de iOS
```bash
# Ver en Xcode Console
```

---

## 🎯 Checklist Final Antes de Lanzar

- [ ] API Key configurada
- [ ] App probada en múltiples dispositivos
- [ ] Todas las imágenes se cargan correctamente
- [ ] Trailers se abren correctamente
- [ ] Navegación funciona sin errores
- [ ] No hay warnings en `flutter analyze`
- [ ] Iconos y nombre de la app personalizados
- [ ] Build release compila sin errores
- [ ] APK/IPA probado en dispositivo real

---

## 📞 Soporte

Si encuentras problemas no listados aquí:

1. Revisa la documentación oficial de Flutter: https://flutter.dev/docs
2. Busca en Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
3. Consulta el GitHub de Flutter: https://github.com/flutter/flutter/issues

---

¡Buena suerte con tu proyecto! 🚀
