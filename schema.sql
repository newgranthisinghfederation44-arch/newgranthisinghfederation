-- NGSF NEW PANEL SYSTEM — run ONLY in a NEW Supabase project.
-- This creates secure role assignment. It does not import or modify the old project.
create extension if not exists pgcrypto;
create type public.ngsf_role as enum ('admin','manager','user');
create table if not exists public.user_roles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role public.ngsf_role not null default 'user',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.user_roles enable row level security;

create or replace function public.ngsf_is_admin()
returns boolean language sql stable security definer set search_path = public
as $$ select exists(select 1 from public.user_roles where user_id = auth.uid() and role = 'admin'); $$;
revoke all on function public.ngsf_is_admin() from public;
grant execute on function public.ngsf_is_admin() to authenticated;

create policy "Users can read their own role; admins can read all roles"
on public.user_roles for select to authenticated
using (user_id = auth.uid() or public.ngsf_is_admin());
create policy "Only admins can insert role assignments"
on public.user_roles for insert to authenticated
with check (public.ngsf_is_admin());
create policy "Only admins can update role assignments"
on public.user_roles for update to authenticated
using (public.ngsf_is_admin()) with check (public.ngsf_is_admin());
create policy "Only admins can delete role assignments"
on public.user_roles for delete to authenticated
using (public.ngsf_is_admin());

-- BOOTSTRAP ADMIN:
-- 1) Create your own user through Supabase Authentication > Users.
-- 2) Copy that user's UUID.
-- 3) As project owner, run this SQL after replacing the UUID.
-- IMPORTANT: Run the INSERT while signed into the Supabase SQL editor as project owner.
-- The first admin cannot grant themselves admin through the website UI.
-- insert into public.user_roles (user_id, role) values ('PASTE-YOUR-AUTH-USER-UUID-HERE', 'admin');
