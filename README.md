# NGSF New Admin / Manager / User Panels

This is a **fresh starter project** for the New Granthi Singh Federation portal. It does not reuse or connect to any previously discussed software/database. It includes a modern responsive UI, Supabase email/password sign-in, role-based dashboard routing and SQL policies for the role table.

## Included
- `/` welcome page
- `/login` secure email/password login
- `/dashboard/admin` full-admin dashboard shell
- `/dashboard/manager` manager dashboard shell
- `/dashboard/user` user dashboard shell
- `supabase/schema.sql` role table and RLS policies
- `.env.local.example` environment variable template

## Important status
This is the first build stage, **not a deployed website yet**. The dashboards currently show placeholder counts and clearly mark data modules as not connected. Membership CRUD, donation payments, ID cards, certificates, QR verification, news, backups and manager permission controls are next implementation steps. No payment gateway is active.

## 1. Create a NEW Supabase project
1. Open Supabase and create a new project (India region if offered and suitable).
2. Open SQL Editor and run `supabase/schema.sql`.
3. Open Project Settings / API and copy the project URL and publishable/anon key.
4. Copy `.env.local.example` to `.env.local`, then fill in `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`.

## 2. Install and run
Requires Node.js 20+.
```bash
npm install
npm run dev
```
Open `http://localhost:3000`.

## 3. Create the first Admin safely
1. In Supabase Authentication > Users, create an account for the organization owner/admin.
2. Copy the user's UUID.
3. In SQL Editor run this, replacing the placeholder UUID:
```sql
insert into public.user_roles (user_id, role)
values ('PASTE-YOUR-AUTH-USER-UUID-HERE', 'admin');
```
4. Sign in at `/login`. The app routes each account according to the assigned role.
5. Additional users should first be created in Supabase Auth; then Admin can assign `manager` or `user` roles using a future admin-management screen, or the project owner can assign roles through SQL for this starter stage.

## Security notes
- Never put a Supabase service-role key in `.env.local` variables prefixed with `NEXT_PUBLIC_` or in frontend code.
- The role table prevents users from changing their own role through the client. Only existing admins can edit roles under the RLS policy.
- The first admin must be bootstrapped by the project owner because no admin exists yet.
- Add server-side route protection, rate limiting, email confirmation, MFA, audit logging and backups before production launch.
- Do not use real member/payment data until the database tables, policies, backups and access tests have been completed.
