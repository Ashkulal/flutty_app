# Money Earning App

A Flutter application that connects to Supabase to display and search various money earning opportunities.

## Features

- ✅ Supabase database integration
- ✅ Search functionality for earning ways
- ✅ Filter by category, difficulty level, and earning range
- ✅ Detailed view for each earning opportunity
- ✅ Beautiful UI with Material Design
- ✅ Responsive layout

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Supabase account

### Installation

1. Clone or download this project
2. Navigate to the project directory:

   ```bash
   cd money_earning_app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Setup Supabase

1. Create a new project on [Supabase](https://supabase.com)

2. Create a table called `earning_ways` with the following columns:

   ```sql
   - id (uuid, Primary Key)
   - title (text, not null)
   - description (text, not null)
   - category (text, not null)
   - estimated_earning (numeric, not null)
   - difficulty (text, not null) - 'Easy', 'Medium', 'Hard'
   - time_required (integer, not null) - in hours
   - requirements (text, not null)
   - is_active (boolean, default: true)
   - created_at (timestamp, default: now())
   ```

3. Add sample data to your table (optional)

4. Get your Supabase URL and Anonymous Key from your project settings

5. Update `lib/main.dart` with your Supabase credentials:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```

### Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── models/
│   └── earning_way.dart      # Data model for earning opportunities
├── services/
│   └── supabase_service.dart # Supabase database operations
└── screens/
    ├── home_screen.dart      # Home screen with search and filters
    └── earning_detail_screen.dart # Detail view for each opportunity
```

## Features Explained

### Search

- Type in the search bar to find earning ways by title, description, or category

### Filters

- **Category**: Filter by type of earning opportunity
- **Difficulty**: Filter by Easy, Medium, or Hard level
- **Reset**: Clear all filters and show all results

### Detail View

- Click on any earning way card to see full details
- Save to favorites
- Share with others
- Start the earning process

## Database Queries

The app uses the following queries:

- **Get all earning ways**: Fetches all active opportunities
- **Search**: Full-text search on title, description, and category
- **Filter by category**: Shows opportunities in selected category
- **Filter by difficulty**: Shows opportunities by difficulty level
- **Filter by earning range**: Shows opportunities within price range
- **Get categories**: Fetches unique categories for dropdown

## Technologies Used

- **Flutter**: UI framework
- **Supabase**: Backend and database
- **Dart**: Programming language

## Sample Data

Insert this data into your Supabase table:

```sql
INSERT INTO earning_ways (id, title, description, category, estimated_earning, difficulty, time_required, requirements, is_active) VALUES
(uuid_generate_v4(), 'Freelance Writing', 'Write articles and blog posts', 'Freelance', 500, 'Easy', 10, 'Good writing skills', true),
(uuid_generate_v4(), 'Virtual Assistant', 'Help businesses with admin tasks', 'Virtual Work', 800, 'Medium', 20, 'Organizational skills', true),
(uuid_generate_v4(), 'Web Development', 'Build websites and web apps', 'Development', 2000, 'Hard', 40, 'Programming knowledge', true);
```

## Future Enhancements

- User authentication
- Save favorite earning ways
- User earnings tracking
- Notifications for new opportunities
- Rating and reviews system

## License

This project is open source and available under the MIT License.

## Support

For issues or questions, please create an issue in the repository.
