create policy "update tracks" on public.tracks for update to authenticated
  using (created_by = auth.uid()) with check (created_by = auth.uid());
