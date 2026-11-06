-- Shared music library for Panda Notebook.
-- Run this once in Supabase > SQL Editor (it's safe to re-run).

-- 1. Public bucket that holds the audio files (public = anyone can play by URL).
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('music', 'music', true, 52428800, array['audio/*'])
on conflict (id) do nothing;

-- Any signed-in user can read, add, or remove files in the music bucket.
create policy "read music"   on storage.objects for select to authenticated using (bucket_id = 'music');
create policy "upload music" on storage.objects for insert to authenticated with check (bucket_id = 'music');
create policy "delete music" on storage.objects for delete to authenticated using (bucket_id = 'music');

-- 2. The playlist: one row per track (title + file path).
create table if not exists public.tracks (
  id         uuid primary key default gen_random_uuid(),
  title      text not null,
  path       text not null,
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  created_at timestamptz not null default now()
);

alter table public.tracks enable row level security;

-- Everyone signed in sees the whole shared playlist.
create policy "read tracks"   on public.tracks for select to authenticated using (true);
-- Anyone signed in can add tracks; each row records who added it.
create policy "insert tracks" on public.tracks for insert to authenticated with check (created_by = auth.uid());
-- Only the person who added a track can remove it.
create policy "delete tracks" on public.tracks for delete to authenticated using (created_by = auth.uid());
