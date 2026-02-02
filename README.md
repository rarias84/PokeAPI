# PokeAPI

Aplicación de ejemplo de Pokédex desarrollada en iOS, que consume la API de [PokeAPI](https://pokeapi.co/).

La app incluye:  

- Desarrollo principal en **UIKit + VIPER**.  
- Desarrollo en **SwiftUI + MVVM** (en progreso, no terminado).  
- Soporte de búsqueda, paginación y gestión de favoritos.  

---

## Requisitos

- Xcode 15 o superior  
- iOS 18+  

---

## Cómo correr el proyecto

1. Clonar el repositorio:  

    ```bash
    git clone <repo-url>
    ```

2. Abrir el proyecto:  

    ```bash
    open PokeAPI.xcodeproj
    ```

3. Seleccionar un simulador o dispositivo físico y ejecutar `Cmd + R`.  

---

## Login

La app incluye un login simple para pruebas.  

- **Usuario:** `tests`  
- **Contraseña:** `1234`  

> No hay persistencia de usuario ni autenticación real, los valores son por defecto para fines de testing.  

---

## Arquitectura

- **UIKit:** VIPER (principal)  
  - Home, Detalle y Favoritos implementados con separación clara de responsabilidades: Presenter, Interactor, Router, View.  
- **SwiftUI:** MVVM (en desarrollo)  
  - Pantallas preliminares y detalle, no integrado con la app principal aún.  

---

## Funcionalidades

- Listado de Pokémon con paginación.  
- Búsqueda por nombre.  
- Visualización de favoritos.  
- Gestión de favoritos (añadir/quitar).  
- Navegación a detalle de Pokémon.  

---

## Diseño

La interfaz sigue, en lo posible, el diseño mostrado en Figma:  
[Ver diseño en Figma](https://www.figma.com/design/pFG8ymYDeuRKDVFkzgPF7v/Pokédex--Community-?node-id=0-1&p=f)  

---

## Problemas conocidos

- La **fluidez en animaciones** de CollectionView puede no ser perfecta en dispositivos antiguos.  
- Los **favoritos** pueden mostrar un comportamiento no totalmente suave en ciertas operaciones rápidas (añadir/quitar).  
- SwiftUI + MVVM aún no está terminado.  

---