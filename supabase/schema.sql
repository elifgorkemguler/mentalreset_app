-- =============================================================================
-- MindFlow — Supabase schema
-- Run this in your Supabase SQL Editor (Project → SQL → New Query).
-- It creates all tables, indexes, and Row-Level-Security policies the app
-- needs. Safe to run multiple times.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- profiles  — onboarding answers + display name, keyed by auth.users.id
-- -----------------------------------------------------------------------------
create table if not exists public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  name          text,
  intent        text check (intent in ('calm', 'recharge', 'clear', 'seen')),
  initial_mood  text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

-- -----------------------------------------------------------------------------
-- mood_checkins  — every time the user picks a mood from the home screen
-- -----------------------------------------------------------------------------
create table if not exists public.mood_checkins (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  mood        text not null,
  note        text,
  created_at  timestamptz not null default now()
);

-- -----------------------------------------------------------------------------
-- thoughts  — captured via Speak/Write, sorted into release / action / unsorted.
-- A thought is "released" when is_released=true (drag-to-trash on the Release
-- screen). We don't hard-delete, so Insights/history can still count it.
-- -----------------------------------------------------------------------------
create table if not exists public.thoughts (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users(id) on delete cascade,
  content      text not null,
  category     text not null default 'release'
                 check (category in ('release', 'action', 'unsorted')),
  intensity    text not null default 'medium'
                 check (intensity in ('low', 'medium', 'high')),
  is_released  boolean not null default false,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- -----------------------------------------------------------------------------
-- tasks  — actionable to-dos, optionally derived from a thought
-- -----------------------------------------------------------------------------
create table if not exists public.tasks (
  id                 uuid primary key default gen_random_uuid(),
  user_id            uuid not null references auth.users(id) on delete cascade,
  thought_id         uuid references public.thoughts(id) on delete set null,
  title              text not null,
  category           text not null
                       check (category in ('work', 'school', 'family', 'personal')),
  estimated_minutes  int,
  why_it_matters     text,
  done_at            timestamptz,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

-- -----------------------------------------------------------------------------
-- focus_sessions  — Pomodoro sessions, optionally linked to a task
-- -----------------------------------------------------------------------------
create table if not exists public.focus_sessions (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references auth.users(id) on delete cascade,
  task_id           uuid references public.tasks(id) on delete set null,
  duration_seconds  int not null,
  completed         boolean not null default false,
  started_at        timestamptz not null default now(),
  ended_at          timestamptz
);

-- -----------------------------------------------------------------------------
-- Indexes
-- -----------------------------------------------------------------------------
create index if not exists idx_thoughts_user_category
  on public.thoughts (user_id, category, is_released, created_at desc);

create index if not exists idx_tasks_user_done
  on public.tasks (user_id, done_at, created_at desc);

create index if not exists idx_moods_user_created
  on public.mood_checkins (user_id, created_at desc);

create index if not exists idx_focus_user_started
  on public.focus_sessions (user_id, started_at desc);

-- -----------------------------------------------------------------------------
-- updated_at trigger helper
-- -----------------------------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_profiles_updated_at on public.profiles;
create trigger trg_profiles_updated_at before update on public.profiles
  for each row execute function public.set_updated_at();

drop trigger if exists trg_thoughts_updated_at on public.thoughts;
create trigger trg_thoughts_updated_at before update on public.thoughts
  for each row execute function public.set_updated_at();

drop trigger if exists trg_tasks_updated_at on public.tasks;
create trigger trg_tasks_updated_at before update on public.tasks
  for each row execute function public.set_updated_at();

-- -----------------------------------------------------------------------------
-- Row Level Security — every user only ever sees their own data
-- -----------------------------------------------------------------------------
alter table public.profiles        enable row level security;
alter table public.mood_checkins   enable row level security;
alter table public.thoughts        enable row level security;
alter table public.tasks           enable row level security;
alter table public.focus_sessions  enable row level security;

-- profiles  (id IS the user id)
drop policy if exists "profiles read own"   on public.profiles;
drop policy if exists "profiles insert own" on public.profiles;
drop policy if exists "profiles update own" on public.profiles;
create policy "profiles read own"   on public.profiles for select using (auth.uid() = id);
create policy "profiles insert own" on public.profiles for insert with check (auth.uid() = id);
create policy "profiles update own" on public.profiles for update using (auth.uid() = id);

-- mood_checkins
drop policy if exists "moods read own"   on public.mood_checkins;
drop policy if exists "moods insert own" on public.mood_checkins;
drop policy if exists "moods update own" on public.mood_checkins;
drop policy if exists "moods delete own" on public.mood_checkins;
create policy "moods read own"   on public.mood_checkins for select using (auth.uid() = user_id);
create policy "moods insert own" on public.mood_checkins for insert with check (auth.uid() = user_id);
create policy "moods update own" on public.mood_checkins for update using (auth.uid() = user_id);
create policy "moods delete own" on public.mood_checkins for delete using (auth.uid() = user_id);

-- thoughts
drop policy if exists "thoughts read own"   on public.thoughts;
drop policy if exists "thoughts insert own" on public.thoughts;
drop policy if exists "thoughts update own" on public.thoughts;
drop policy if exists "thoughts delete own" on public.thoughts;
create policy "thoughts read own"   on public.thoughts for select using (auth.uid() = user_id);
create policy "thoughts insert own" on public.thoughts for insert with check (auth.uid() = user_id);
create policy "thoughts update own" on public.thoughts for update using (auth.uid() = user_id);
create policy "thoughts delete own" on public.thoughts for delete using (auth.uid() = user_id);

-- tasks
drop policy if exists "tasks read own"   on public.tasks;
drop policy if exists "tasks insert own" on public.tasks;
drop policy if exists "tasks update own" on public.tasks;
drop policy if exists "tasks delete own" on public.tasks;
create policy "tasks read own"   on public.tasks for select using (auth.uid() = user_id);
create policy "tasks insert own" on public.tasks for insert with check (auth.uid() = user_id);
create policy "tasks update own" on public.tasks for update using (auth.uid() = user_id);
create policy "tasks delete own" on public.tasks for delete using (auth.uid() = user_id);

-- focus_sessions
drop policy if exists "focus read own"   on public.focus_sessions;
drop policy if exists "focus insert own" on public.focus_sessions;
drop policy if exists "focus update own" on public.focus_sessions;
drop policy if exists "focus delete own" on public.focus_sessions;
create policy "focus read own"   on public.focus_sessions for select using (auth.uid() = user_id);
create policy "focus insert own" on public.focus_sessions for insert with check (auth.uid() = user_id);
create policy "focus update own" on public.focus_sessions for update using (auth.uid() = user_id);
create policy "focus delete own" on public.focus_sessions for delete using (auth.uid() = user_id);

-- -----------------------------------------------------------------------------
-- Auto-create a profiles row whenever a new auth user signs up
-- -----------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, name)
  values (new.id, coalesce(new.raw_user_meta_data->>'name', null));
  return new;
end;
$$ language plpgsql;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
