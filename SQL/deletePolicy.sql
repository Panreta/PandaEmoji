drop policy if exists "delete tracks" on public.tracks;
create policy "delete tracks" on public.tracks for delete to authenticated using (true);

drop policy if exists "update tracks" on public.tracks;
create policy "update tracks" on public.tracks for update to authenticated using (true) with check (true);
