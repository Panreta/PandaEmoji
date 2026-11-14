create table if not exists public.kit (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  kind       text not null,            -- 'note' | 'link' | 'media'
  content    text,                     -- note text, or link label
  url        text,                     -- link URL
  path       text,                     -- storage path for photo/video
  mkind      text,                     -- 'image' | 'video'
  created_at timestamptz not null default now()
);
alter table public.kit enable row level security;
create policy "read own kit"   on public.kit for select to authenticated using (user_id = auth.uid());
create policy "insert own kit" on public.kit for insert to authenticated with check (user_id = auth.uid());
create policy "delete own kit" on public.kit for delete to authenticated using (user_id = auth.uid());
