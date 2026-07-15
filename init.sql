CREATE TABLE IF NOT EXISTS admin_users (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  email TEXT,
  discord_name TEXT,
  role TEXT NOT NULL DEFAULT 'recrutador',
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS applications (
  id SERIAL PRIMARY KEY,
  application_number TEXT NOT NULL UNIQUE,
  token TEXT NOT NULL UNIQUE,
  status TEXT NOT NULL DEFAULT 'inscricao_iniciada',
  step INTEGER NOT NULL DEFAULT 1,
  consent_accepted BOOLEAN NOT NULL DEFAULT FALSE,
  consent_text TEXT,
  personal_data JSONB,
  character_data JSONB,
  experience_data JSONB,
  staff_exp_data JSONB,
  punishment_data JSONB,
  availability_data JSONB,
  motivation_data JSONB,
  quiz_scores JSONB,
  total_score REAL,
  admin_score REAL,
  classification TEXT,
  assigned_to_id INTEGER REFERENCES admin_users(id),
  possible_duplicate BOOLEAN NOT NULL DEFAULT FALSE,
  message TEXT,
  interview_date TEXT,
  final_result TEXT,
  ip_address TEXT,
  user_agent TEXT,
  country TEXT,
  city TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  submitted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS questions (
  id SERIAL PRIMARY KEY,
  text TEXT NOT NULL,
  type TEXT NOT NULL,
  category TEXT NOT NULL,
  difficulty TEXT NOT NULL DEFAULT 'basico',
  weight REAL NOT NULL DEFAULT 1,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  is_eliminatory BOOLEAN NOT NULL DEFAULT FALSE,
  requires_manual_review BOOLEAN NOT NULL DEFAULT FALSE,
  options JSONB,
  correct_answer TEXT,
  explanation TEXT,
  correct_rate REAL,
  times_answered INTEGER DEFAULT 0,
  times_correct INTEGER DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS quiz_answers (
  id SERIAL PRIMARY KEY,
  application_id INTEGER NOT NULL REFERENCES applications(id),
  question_id INTEGER NOT NULL REFERENCES questions(id),
  answer TEXT NOT NULL,
  is_correct BOOLEAN,
  score REAL,
  manual_score REAL,
  manual_comment TEXT,
  reviewed_by_id INTEGER,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS application_quiz_sessions (
  id SERIAL PRIMARY KEY,
  application_id INTEGER NOT NULL REFERENCES applications(id),
  question_ids JSONB NOT NULL,
  time_spent_seconds INTEGER,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS status_history (
  id SERIAL PRIMARY KEY,
  application_id INTEGER NOT NULL REFERENCES applications(id),
  status TEXT NOT NULL,
  changed_by_id INTEGER REFERENCES admin_users(id),
  reason TEXT,
  changed_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS candidate_notes (
  id SERIAL PRIMARY KEY,
  application_id INTEGER NOT NULL REFERENCES applications(id),
  content TEXT NOT NULL,
  author_id INTEGER REFERENCES admin_users(id),
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS interviews (
  id SERIAL PRIMARY KEY,
  application_id INTEGER NOT NULL REFERENCES applications(id),
  interviewer_id INTEGER REFERENCES admin_users(id),
  scheduled_at TIMESTAMP NOT NULL,
  discord_channel TEXT,
  duration_minutes INTEGER,
  status TEXT NOT NULL DEFAULT 'agendada',
  attended BOOLEAN,
  notes TEXT,
  category_scores JSONB,
  recommendation TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS training (
  id SERIAL PRIMARY KEY,
  application_id INTEGER NOT NULL REFERENCES applications(id),
  instructor_id INTEGER REFERENCES admin_users(id),
  status TEXT NOT NULL DEFAULT 'nao_iniciado',
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  modules JSONB,
  scores JSONB,
  feedbacks JSONB,
  result TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS admin_logs (
  id SERIAL PRIMARY KEY,
  action TEXT NOT NULL,
  user_id INTEGER REFERENCES admin_users(id),
  target_id INTEGER,
  target_type TEXT,
  details JSONB,
  ip_address TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO admin_users (username, password_hash, role, active)
VALUES
  ('admin', 'd47cf97fd9cbd0f51fa3b5e5539191bc7781a9a5558b9ef2308d89cbe3467200', 'direcao', TRUE),
  ('coordenador', '685491a4bdd32bcd4855c1aa2a1dcef94951bee4b2d7298b333f16fcb146b995', 'coordenacao', TRUE)
ON CONFLICT (username) DO NOTHING;
