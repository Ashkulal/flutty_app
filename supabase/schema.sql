-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Todos Table
CREATE TABLE todos (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  is_completed BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sample Data
INSERT INTO todos (name) VALUES
('Set up Supabase project'),
('Build Flutter Todo App'),
('Add premium UI features'),
('Launch to production');

-- Policies (RLS)
ALTER TABLE todos ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public access for now" ON todos FOR ALL USING (true);
