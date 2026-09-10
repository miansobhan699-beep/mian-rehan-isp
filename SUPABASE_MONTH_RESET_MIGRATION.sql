-- Run this in Supabase SQL Editor once.
-- It allows ONLY authenticated staff whose staff_profiles.role is admin
-- to delete payment rows. This is safer than opening DELETE to every user.

alter table public.payments enable row level security;

grant delete on table public.payments to authenticated;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname='public' and tablename='payments'
      and policyname='Admins can delete payment records'
  ) then
    create policy "Admins can delete payment records"
      on public.payments
      for delete
      to authenticated
      using (
        exists (
          select 1
          from public.staff_profiles sp
          where sp.user_id = auth.uid()
            and lower(coalesce(sp.role,'')) = 'admin'
            and coalesce(sp.active,true) = true
        )
      );
  end if;
end $$;
