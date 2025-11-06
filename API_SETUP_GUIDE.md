# Guía de Configuración de la API de TMDB

## Paso a Paso para Obtener tu API Key

### 1. Crear una Cuenta en TMDB

1. Ve a [https://www.themoviedb.org/signup](https://www.themoviedb.org/signup)
2. Completa el formulario de registro:
   - Nombre de usuario
   - Contraseña
   - Email
   - Acepta los términos y condiciones
3. Verifica tu email haciendo clic en el enlace que te enviarán

### 2. Solicitar API Key

1. Inicia sesión en tu cuenta de TMDB
2. Haz clic en tu avatar en la esquina superior derecha
3. Ve a **Settings** (Configuración)
4. En el menú lateral, selecciona **API**
5. Haz clic en **"Request an API Key"** o **"Create"**
6. Selecciona **"Developer"** (para uso no comercial)
7. Acepta los términos de uso
8. Completa el formulario:
   - **Application Name**: Movie App Flutter (o el nombre que prefieras)
   - **Application URL**: http://localhost (si no tienes una URL)
   - **Application Summary**: Aplicación de películas desarrollada en Flutter para aprendizaje
9. Haz clic en **Submit**

### 3. Copiar tu API Key

1. Una vez aprobada (es instantáneo), verás tu API Key
2. Hay dos versiones:
   - **API Key (v3 auth)**: Esta es la que necesitas ✅
   - **API Read Access Token (v4 auth)**: No uses esta
3. Copia la **API Key (v3 auth)**

### 4. Configurar en el Proyecto

1. Abre el archivo `lib/services/tmdb_service.dart`
2. Busca esta línea:
```dart
static const String apiKey = 'TU_API_KEY_AQUI';
```
3. Reemplázala con tu API Key:
```dart
static const String apiKey = 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';
```
4. Guarda el archivo

### 5. Verificar que Funciona

Ejecuta la aplicación:
```bash
flutter run
```

Si todo está correcto, deberías ver las películas cargándose en la pantalla principal.

## Límites de la API Gratuita

- **40 requests cada 10 segundos** por IP
- **Sin límite diario** para cuentas gratuitas
- **Perfecto para desarrollo y aprendizaje**

## Ejemplo de API Key Válida

Tu API Key debería verse similar a esto (ejemplo ficticio):
```
a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
```

Son 32 caracteres alfanuméricos.

## Errores Comunes

### Error 401: Invalid API key
- **Causa**: API Key incorrecta o mal copiada
- **Solución**: Verifica que copiaste toda la key sin espacios extra

### Error 429: Too Many Requests
- **Causa**: Excediste el límite de 40 requests/10 segundos
- **Solución**: Espera unos segundos y vuelve a intentar

### No se cargan las películas
- **Causa**: No hay conexión a internet o API Key no configurada
- **Solución**: Verifica tu conexión y que configuraste correctamente la API Key

## Recursos Adicionales

- **Documentación oficial**: [https://developers.themoviedb.org/3](https://developers.themoviedb.org/3)
- **Foro de TMDB**: [https://www.themoviedb.org/talk](https://www.themoviedb.org/talk)
- **Estado de la API**: [https://status.themoviedb.org/](https://status.themoviedb.org/)

## Seguridad

⚠️ **IMPORTANTE**: 
- No compartas tu API Key públicamente
- No la subas a repositorios públicos de GitHub
- Si la expones accidentalmente, puedes regenerarla desde tu panel de TMDB

## Soporte

Si tienes problemas para obtener tu API Key:
1. Contacta el soporte de TMDB: [https://www.themoviedb.org/talk](https://www.themoviedb.org/talk)
2. Revisa la documentación oficial
3. Verifica que tu cuenta está verificada (email)

---

¡Listo! Una vez configurada tu API Key, podrás disfrutar de todas las funcionalidades de la aplicación. 🎬
