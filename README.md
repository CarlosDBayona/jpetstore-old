# JPetStore Web App (Modernizada)

Esta es la versión modernizada de la aplicación web **JPetStore**, configurada para funcionar con **PostgreSQL**.

---

## Requisitos previos

* **Java JDK** (versión compatible con el proyecto, ej. Java 17 o superior)
* **Docker / PostgreSQL** en ejecución en el puerto `5432`

---

## Instrucciones de ejecución

Abre una terminal en la raíz del proyecto y ejecuta los siguientes comandos:

### 1. Compilar el proyecto

```bash
.\mvnw clean package "-DskipTests" "-Denforcer.skip=true"
```

### 2. Desplegar y ejecutar la aplicación

```bash
.\mvnw cargo:run "-Denforcer.skip=true"
```