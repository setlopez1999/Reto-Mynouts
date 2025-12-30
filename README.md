# 📝 MyNouts - Aplicación de Notas con Flutter

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green.svg)

Una aplicación moderna de gestión de notas desarrollada con Flutter, que implementa arquitectura limpia y las mejores prácticas del ecosistema Flutter moderno.

## 📸 Screenshots

> Capturas pronto

## ✨ Características

- ✅ **CRUD Completo**: Crear, leer, actualizar y eliminar notas
- 📱 **Diseño Responsive**: Adaptable a móvil, tablet y desktop
- 🎨 **Material Design 3**: Interfaz moderna con tema oscuro
- 💾 **Persistencia Local**: Los datos se guardan en SQLite
- 🔗 **Deep Links**: Soporte completo para enlaces profundos
- ⚡ **Tiempo Real**: Actualización automática de la UI con Streams
- 🎯 **Estado Global**: Gestión eficiente con Riverpod

## 🏗️ Arquitectura

El proyecto sigue una arquitectura en capas con separación clara de responsabilidades:

```
lib/
├── main.dart                    # Punto de entrada y configuración
├── data/
│   └── database/               # Capa de datos (Drift + SQLite)
├── providers/                  # Estado global (Riverpod)
├── presentation/
│   └── screens/               # UI (Pantallas)
└── router/                    # Navegación (GoRouter)
```

### 📊 Flujo de Datos

```
UI (Presentation) → Riverpod (Providers) → Database (Data) → SQLite
```

## 🛠️ Tecnologías Utilizadas

| Tecnología | Propósito | Versión |
|------------|-----------|---------|
| **Flutter** | Framework UI | 3.0+ |
| **Riverpod** | Gestión de estado | ^2.4.0 |
| **GoRouter** | Navegación declarativa | ^13.0.0 |
| **Drift** | ORM para SQLite | ^2.14.0 |
| **Google Fonts** | Tipografía | ^6.1.0 |

## 🚀 Instalación

1. **Clona el repositorio**
   ```bash
   git clone https://github.com/setlopez1999/Reto-Mynouts.git
   cd Reto-Mynouts
   ```

2. **Instala las dependencias**
   ```bash
   flutter pub get
   ```

3. **Genera el código de Drift**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Ejecuta la aplicación**
   ```bash
   flutter run
   ```

## 📱 Plataformas Soportadas DDDDDDDDDDDDDDDDDDDDDDD

- ✅ Android - (Verificado)
- 🛠️ iOS
- 🛠️ Web
- 🛠️ Windows

## 🗺️ Rutas de Navegación

| Ruta | Pantalla | Descripción |
|------|----------|-------------|
| `/` | HomeScreen | Lista de todas las notas |
| `/note/create` | NoteFormScreen | Crear nueva nota |
| `/note/:id` | NoteDetailScreen | Ver detalle de nota (Deep Link) |
| `/note/:id/edit` | NoteFormScreen | Editar nota existente |

## 🏛️ Arquitectura Detallada

### Capa de Datos (`data/`)
- **Responsabilidad**: Comunicación con SQLite
- **Componentes**:
  - `app_database.dart`: Implementación del CRUD
  - `tables.dart`: Definición del schema
  - `app_database.g.dart`: Código generado por Drift

### Capa de Providers (`providers/`)
- **Responsabilidad**: Estado global reactivo
- **Providers**:
  - `databaseProvider`: Singleton de AppDatabase
  - `notesStreamProvider`: Stream de todas las notas
  - `noteProvider.family`: Stream de nota específica por ID

### Capa de Presentación (`presentation/`)
- **Responsabilidad**: Interfaz de usuario
- **Pantallas**:
  - `home_screen.dart`: Grid responsive de notas
  - `note_detail_screen.dart`: Vista completa de una nota
  - `note_form_screen.dart`: Formulario crear/editar

### Capa de Router (`router/`)
- **Responsabilidad**: Navegación declarativa
- **Características**: Deep links, rutas tipadas, parámetros en URL

## 🎯 Decisiones Técnicas

### ¿Por qué Riverpod?
- Gestión de estado moderna y type-safe
- Mejor testabilidad que Provider clásico
- Reactividad automática con Streams

### ¿Por qué Drift?
- Type-safe queries en compile-time
- Migraciones automáticas
- Excelente performance con SQLite

### ¿Por qué GoRouter?
- Navegación declarativa
- Soporte nativo de deep links
- Integración perfecta con Material 3



## 📄 LICENCIA

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 👤 AUTOR

**Set Lopez**
- GitHub: [@setlopez1999](https://github.com/setlopez1999)

## 🙏 Agradecimientos

- Proyecto desarrollado como parte de un reto técnico para FractalUp
- Inspirado en las mejores prácticas de la comunidad Flutter

---

⭐ Si te gustó este reto, ¡dame una estrella en GitHub!

