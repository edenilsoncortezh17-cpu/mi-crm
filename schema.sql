-- Planner 2026 · esquema de Supabase
-- Pégalo completo en Supabase → SQL Editor → New query → Run.

-- 1. Documentos del planner (días, meses, hábitos, contactos, gym, finanzas…)
create table if not exists public.planner_docs (
  user_id    uuid not null default auth.uid() references auth.users on delete cascade,
  key        text not null,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, key)
);

-- 2. Bandeja "Por clasificar" de cobros detectados (bot de Gmail)
create table if not exists public.fin_inbox (
  id         text primary key,
  user_id    uuid not null default auth.uid() references auth.users on delete cascade,
  data       jsonb not null,
  created_at timestamptz not null default now()
);

-- 3. Seguridad: cada usuario solo ve y edita sus propios datos
alter table public.planner_docs enable row level security;
alter table public.fin_inbox    enable row level security;

drop policy if exists "own docs"  on public.planner_docs;
drop policy if exists "own inbox" on public.fin_inbox;

create policy "own docs" on public.planner_docs
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own inbox" on public.fin_inbox
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 4. Sincronización en vivo entre iPhone, iPad y PC
alter table public.planner_docs replica identity full;
alter table public.fin_inbox    replica identity full;
alter publication supabase_realtime add table public.planner_docs;
alter publication supabase_realtime add table public.fin_inbox;
