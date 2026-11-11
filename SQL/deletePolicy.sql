drop policy if exists "delete tracks" on public.tracks;
create policy "delete tracks" on public.tracks for delete to authenticated using (auth.uid() = 'YourID');

drop policy if exists "update tracks" on public.tracks;
create policy "update tracks" on public.tracks for update to authenticated using (auth.uid() = 'YourID') with check (auth.uid() = 'YourID');
