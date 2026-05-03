# Supabase setup — Mental Reset

Three steps to wire the app to your Supabase project.

## 1. Create the project

1. Go to <https://app.supabase.com> → **New project**.
2. Pick a region close to your users.
3. Save the database password somewhere safe.

## 2. Run the schema

1. Open **SQL Editor** in the Supabase dashboard.
2. Open `supabase/schema.sql` from this repo, copy the entire file.
3. Paste it into a new query and click **Run**.

The script is idempotent (safe to re-run). It creates:

- `profiles`, `thoughts`, `tasks`, `mood_checkins`, `focus_sessions`
- Indexes for the common queries the app makes
- Row-Level-Security policies — every user only sees their own rows
- A trigger that auto-creates a `profiles` row when a user signs up

## 3. Plug the keys into the app

In **Project Settings → API** copy:

- **Project URL**
- **anon public key**

Open `lib/core/supabase/supabase_config.dart` and paste them in:

```dart
static const String url = 'https://xxxxxxxxxx.supabase.co';
static const String anonKey = 'eyJhbGc...';
```

That's it. Run `flutter run` — the app will detect the keys and switch from
mock data to live Supabase queries automatically. If the keys are blank, the
app keeps running on local mock data so you don't get blocked.

## Auth

Auth is **not** wired up yet — the schema is ready (RLS expects an
`auth.uid()`) but the app's login screen still routes straight to onboarding.
We'll add `signInWithPassword` / `signUp` calls when we replace the mock auth
flow with real Supabase auth.
