# JPetStore Web App (Modernizada)

Esta es la versión modernizada de la aplicación web **JPetStore**, configurada para funcionar con **PostgreSQL** en vez de la base HSQLDB embebida original. El frontend legado (`Category.jsp`) también consume en vivo, vía `fetch()`, la nueva API REST del proyecto hermano [jpetstore-partial](https://github.com/CarlosDBayona/jpetstore-partial) (con *fallback* al render server-side si la API no responde).

---

## Requisitos previos

* **Java JDK** (versión compatible con el proyecto, ej. Java 17 o superior)
* **Docker / PostgreSQL** en ejecución en el puerto `5432`

La cadena de conexión se resuelve por variables de entorno (con valores por defecto para desarrollo local):

| Variable | Por defecto |
|---|---|
| `DB_URL` | `jdbc:postgresql://localhost:5432/jpetstore` |
| `DB_USERNAME` | `jpetstore` |
| `DB_PASSWORD` | `jpetstore_pass` |

El esquema y los datos semilla (`src/main/resources/database/jpetstore-hsqldb-schema.sql` y `-dataload.sql`) se aplican automáticamente al arrancar la aplicación (`jdbc:initialize-database` en `applicationContext.xml`).

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

### Opción alternativa: stack completo con Docker Compose

Para levantar este proyecto junto con [jpetstore-partial](https://github.com/CarlosDBayona/jpetstore-partial) y una única base PostgreSQL compartida (con los datos ya sembrados desde los scripts de este proyecto), usa `plans/docker-compose.yml` en `jpetstore-partial`, con ambos repositorios como carpetas hermanas:

```bash
cd ../jpetstore-partial/plans
docker compose up --build -d
```