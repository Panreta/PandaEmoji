create table public.relax (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  title      text not null default '',
  body       text not null default '',
  created_at timestamptz not null default now()
);
alter table public.relax enable row level security;
create policy "read own relax"   on public.relax for select to authenticated using (user_id = auth.uid());
create policy "insert own relax" on public.relax for insert to authenticated with check (user_id = auth.uid());
create policy "update own relax" on public.relax for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "delete own relax" on public.relax for delete to authenticated using (user_id = auth.uid());
