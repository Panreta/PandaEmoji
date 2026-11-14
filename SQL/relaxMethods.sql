create table if not exists public.relax (
  user_id    uuid primary key default auth.uid() references auth.users (id) on delete cascade,
  text       text not null default '',
  updated_at timestamptz not null default now()
);
alter table public.relax enable row level security;
create policy "read own relax"   on public.relax for select to authenticated using (user_id = auth.uid());
create policy "insert own relax" on public.relax for insert to authenticated with check (user_id = auth.uid());
create policy "update own relax" on public.relax for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
