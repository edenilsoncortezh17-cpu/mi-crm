# Planner 2026

Planner personal: día, mes, hábitos, contactos, proyectos y metas, gym y finanzas (previsto vs real).
Una sola página (`index.html`) publicada en GitHub Pages, con los datos en Supabase y sincronización en vivo entre dispositivos.

## Puesta en marcha

### 1. Supabase
1. Crea un proyecto gratis en https://supabase.com.
2. En **SQL Editor**, pega el contenido de `schema.sql` y pulsa **Run**.
3. En **Project Settings → API** copia la **Project URL** y la **Publishable key** (sb_publishable_…).
4. Ponlas en `index.html`, en el bloque `CONFIGURACIÓN SUPABASE`:
   ```js
   const SUPABASE_URL='https://xxxx.supabase.co';
   const SUPABASE_KEY='eyJ...';
   ```
   La clave anon es pública por diseño: la seguridad la dan las políticas RLS del esquema (cada usuario solo accede a sus filas).
5. En **Authentication → URL Configuration**, pon como **Site URL** la dirección de GitHub Pages (paso 2).

### 2. GitHub Pages
1. Sube este repositorio a GitHub.
2. **Settings → Pages → Source: Deploy from a branch → `main` / root**.
3. La web queda en `https://TU-USUARIO.github.io/NOMBRE-DEL-REPO/`.

### 3. Primer uso
- Abre la URL, pulsa **Crear cuenta**, confirma el email y entra.
- Para traer tus datos de la versión anterior: allí pulsa **Copiar copia de seguridad**; aquí pulsa **Pegar copia de seguridad**.
- En iPhone/iPad: Safari → Compartir → **Añadir a pantalla de inicio** para usarlo como app.

## Estructura de datos
- `planner_docs (user_id, key, data jsonb)`: un documento por clave: `day-AAAA-MM-DD`, `month-AAAA-MM`, `habits`, `contacts`, `projects`, `goals`, `dump`, `gym`, `fin-config`, `fin-AAAA-MM`.
- `fin_inbox (id, user_id, data jsonb)`: cobros pendientes de clasificar. `data` = `{ date, desc, amount, from }`. El `id` debe ser único (p. ej. el id del correo) para no duplicar.
