
# Lessons App

## Overview

The **Tuta App** is a Flutter application that provides users with a variety of lessons in different categories, including Educational, Personal Development, and Cuisine. The app fetches lesson data from a Supabase backend and displays it in a visually appealing carousel format.

## Features

- **User-Friendly Interface**: Easy-to-navigate UI with smooth animations.
- **Dynamic Content**: Fetches lesson data from Supabase in real-time.
- **Multiple Categories**: View lessons categorized into Educational, Personal Development, and Cuisine.
- **Carousel View**: Lessons are displayed in a carousel format for an engaging experience.
- **Responsive Design**: Works seamlessly on different screen sizes.

## Technology Stack

- **Flutter**: The UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- **Supabase**: An open-source Firebase alternative that provides a backend-as-a-service with real-time capabilities.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Supabase account

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/lessons-app.git
   cd lessons-app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**:
   - Create a Supabase account and set up a new project.
   - Create tables for `educational_lessons`, `personal_development_lessons`, and `cuisine_lessons`.
   - Insert sample data into the tables.
   - Get the API URL and anon key from your Supabase project settings.

4. **Configure Supabase in your app**:
   - Update your Supabase URL and anon key in the `lib/main.dart` file.

   ```dart
   final supabaseUrl = 'https://your-supabase-url.supabase.co';
   final supabaseKey = 'your-anon-key';
   ```

5. **Run the app**:
   ```bash
   flutter run
   ```


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact

For any inquiries, please contact [jimmy.james365@gmail.com].

---

Happy Coding!
```

