# Supabase Setup Guide

## Step 1: Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up or login
3. Click "New Project"
4. Fill in project details:
   - **Name**: money-earning-app
   - **Database Password**: Create a strong password
   - **Region**: Choose your region
5. Click "Create new project" and wait for setup

## Step 2: Create Database Table

Once your project is created:

1. Go to **SQL Editor** in the left sidebar
2. Click **New Query**
3. Copy and paste the following SQL:

```sql
CREATE TABLE earning_ways (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(100) NOT NULL,
  estimated_earning NUMERIC(10,2) NOT NULL,
  difficulty VARCHAR(20) NOT NULL CHECK (difficulty IN ('Easy', 'Medium', 'Hard')),
  time_required INTEGER NOT NULL,
  requirements TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for better search performance
CREATE INDEX idx_earning_ways_title ON earning_ways(title);
CREATE INDEX idx_earning_ways_category ON earning_ways(category);
CREATE INDEX idx_earning_ways_difficulty ON earning_ways(difficulty);
CREATE INDEX idx_earning_ways_is_active ON earning_ways(is_active);
```

4. Click **Run** to execute the query

## Step 3: Add Sample Data

1. Go to **SQL Editor** again
2. Click **New Query**
3. Copy and paste:

```sql
INSERT INTO earning_ways (title, description, category, estimated_earning, difficulty, time_required, requirements, is_active)
VALUES
(
  'Freelance Writing',
  'Write articles, blog posts, and content for websites. Get paid per article or per word.',
  'Freelance',
  500,
  'Easy',
  10,
  'Good writing skills, English proficiency, portfolio of work',
  true
),
(
  'Graphic Design',
  'Create logos, graphics, and visual designs for clients online.',
  'Design',
  1200,
  'Medium',
  25,
  'Design software knowledge (Photoshop, Figma), portfolio',
  true
),
(
  'Virtual Assistant',
  'Manage emails, schedules, and administrative tasks for businesses.',
  'Virtual Work',
  800,
  'Medium',
  20,
  'Organizational skills, communication, time management',
  true
),
(
  'Social Media Manager',
  'Manage social media accounts and create engaging content.',
  'Social Media',
  900,
  'Easy',
  15,
  'Social media knowledge, creative thinking',
  true
),
(
  'Web Development',
  'Build and maintain websites and web applications.',
  'Development',
  2000,
  'Hard',
  40,
  'HTML, CSS, JavaScript, backend language knowledge',
  true
),
(
  'Mobile App Development',
  'Develop iOS and Android mobile applications.',
  'Development',
  2500,
  'Hard',
  50,
  'Flutter, React Native, or Swift knowledge',
  true
),
(
  'Content Creator',
  'Create YouTube videos, TikTok, or Twitch content.',
  'Content Creation',
  1500,
  'Medium',
  30,
  'Video editing, consistent content creation, audience building',
  true
),
(
  'Tutoring',
  'Teach students online subjects like Math, English, Science.',
  'Education',
  600,
  'Easy',
  12,
  'Subject expertise, communication skills',
  true
),
(
  'Data Entry',
  'Enter and manage data for companies.',
  'Administrative',
  400,
  'Easy',
  8,
  'Accuracy, typing speed, attention to detail',
  true
),
(
  'Translation',
  'Translate documents and content between languages.',
  'Language',
  700,
  'Medium',
  18,
  'Fluency in multiple languages',
  true
);
```

4. Click **Run** to add sample data

## Step 4: Enable Row Level Security (Optional but Recommended)

1. Go to **Authentication** > **Policies**
2. Click **Enable RLS** for the `earning_ways` table
3. Add a policy to allow anyone to read (SELECT):
   - Click **New Policy**
   - Choose **For custom expressions**
   - Use: `true` (allows all SELECT queries)
   - Click **Review**
   - Click **Save policy**

## Step 5: Get Your API Keys

1. Go to **Settings** > **API** in the left sidebar
2. Under **Project API keys**, you'll find:
   - **Project URL**: Copy this (YOUR_SUPABASE_URL)
   - **anon public**: Copy this (YOUR_SUPABASE_ANON_KEY)

## Step 6: Update Flutter App

1. Open `lib/main.dart`
2. Replace the Supabase URL and key:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',  // Paste your URL here
  anonKey: 'YOUR_SUPABASE_ANON_KEY',  // Paste your anon key here
);
```

Example (don't use these, get your own):

```dart
await Supabase.initialize(
  url: 'https://abcdefghij.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
);
```

## Step 7: Run the App

```bash
flutter pub get
flutter run
```

## Verify Everything Works

1. Open the app
2. You should see the sample data loaded
3. Try searching for "Writing"
4. Try filtering by category "Development"
5. Click on any item to see details

## Troubleshooting

### "Failed to fetch earning ways"

- Check your Supabase URL and key are correct
- Verify the table `earning_ways` exists
- Check Row Level Security policies

### "No data showing"

- Go to Supabase dashboard > **Table Editor**
- Click `earning_ways` table
- Verify sample data is inserted

### Connection timeout

- Check your internet connection
- Verify Supabase project status (not paused)
- Check if region is accessible from your location

## Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [SQL Basics](https://supabase.com/docs/guides/database/overview)
