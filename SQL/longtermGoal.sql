-- Long-term goals for Panda Notebook (per user, private).
-- Run once in Supabase > SQL Editor. Select all, then Run.

create table if not exists public.goals (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  text       text not null,
  done       boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.goals enable row level security;

-- each signed-in user sees and edits only their own goals
create policy "read own goals"   on public.goals for select to authenticated using (user_id = auth.uid());
create policy "insert own goals" on public.goals for insert to authenticated with check (user_id = auth.uid());
create policy "update own goals" on public.goals for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "delete own goals" on public.goals for delete to authenticated using (user_id = auth.uid());
