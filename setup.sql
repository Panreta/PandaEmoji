-- Panda Notebook: run this once in Supabase > SQL Editor.

-- 1. Journal entries: one row per notebook per day.
create table if not exists public.entries (
  user_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  nb         text not null,                                   -- notebook, e.g. 'guitar'
  date       text not null check (date ~ '^\d{4}-\d{2}-\d{2}$'),
  tile       int,                                             -- garden tile the day was planted on
  items      jsonb not null default '[]'::jsonb,              -- the bullets
  updated_at timestamptz not null default now(),
  primary key (user_id, nb, date)
);

-- Only the signed-in owner of a row can see or change it.
alter table public.entries enable row level security;

create policy "read own entries"   on public.entries for select to authenticated using (user_id = auth.uid());
create policy "insert own entries" on public.entries for insert to authenticated with check (user_id = auth.uid());
create policy "update own entries" on public.entries for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "delete own entries" on public.entries for delete to authenticated using (user_id = auth.uid());

-- 2. Private bucket for photos and videos (50 MB per file, the free-plan maximum).
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('media', 'media', false, 52428800, array['image/*', 'video/*'])
on conflict (id) do nothing;

-- Files live under <your user id>/..., and only you can read, add, or delete them.
create policy "read own media" on storage.objects for select to authenticated
  using (bucket_id = 'media' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "upload own media" on storage.objects for insert to authenticated
  with check (bucket_id = 'media' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "delete own media" on storage.objects for delete to authenticated
  using (bucket_id = 'media' and (storage.foldername(name))[1] = auth.uid()::text);
