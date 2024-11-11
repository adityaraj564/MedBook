
# MedBook 📚

MedBook is an iOS/iPadOS app that allows users to search for books, sort them by various criteria, and bookmark them for later access. The app includes a user authentication system with signup and login features, leveraging a local database to store user and bookmark information.

## Table of Contents
- [Features](#features)
- [Architecture](#architecture)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Folder Structure](#folder-structure)
- [API References](#api-references)
- [Acknowledgements](#acknowledgements)

## Features

### Level 1: User Authentication
- **Landing Screen**: Users can choose to sign up or log in.
- **Signup Screen**: Allows new users to register using an email, password, and country selection.
  - **Country Selection**: Uses an external API to populate a country picker.
  - **Email and Password Validation**: Validates email format and password strength.
- **Login Screen**: Allows returning users to log in using stored credentials.

### Level 2: Book Search and Sort
- **Search for Books**: Users can search for books by title, with results displayed in a table view.
- **Pagination and Sorting**: Results can be paginated and sorted by title, rating, or popularity.

### Level 3: Bookmarking
- **Bookmark Feature**: Users can bookmark/unbookmark books, with bookmarked items stored locally.
- **Bookmarked Screen**: A separate screen to view all bookmarked books.

## Architecture

MedBook is built using the **Model-View-ViewModel (MVVM)** architecture pattern, which separates the data handling, UI logic, and view representation, providing a scalable and maintainable codebase.

### Key Components
- **Model**: Defines data structures (e.g., `User`, `Book`, `Country`).
- **ViewModel**: Handles business logic, data transformations, and communicates with views (e.g., `SignupViewModel`, `HomeViewModel`).
- **View**: User interface elements, interacting with view models to display data and handle user input (e.g., `HomeViewController`, `SignupViewController`).
- **Services**: Manages API requests and local data storage (e.g., `APIService`, `LocalStorage`).

## Requirements
- iOS 14.0+
- Xcode 13.0+
- Swift 5

## Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/adityaraj564/MedBook.git
   cd MedBook
   ```

2. **Open the Project**
   - Open `MedBook.xcodeproj` in Xcode.

3. **Build and Run**
   - Select a simulator or connected device in Xcode.
   - Press `Cmd + R` to build and run the app.

## Usage

1. **Launch the App**
   - On the landing screen, choose to sign up or log in.

2. **Sign Up**
   - Enter a valid email and password.
   - Select your country from the list. The app uses an external API to populate the country picker.

3. **Login**
   - Enter your credentials to access the home screen.

4. **Search for Books**
   - Use the search bar on the home screen to find books by title.
   - Sort results by title, rating, or popularity.

5. **Bookmark Books**
   - Swipe on a book to bookmark or remove it from your bookmarks.
   - Access bookmarked books via the "Bookmarks" button on the home screen.

6. **Logout**
   - Use the logout button to clear your session and return to the landing screen.

## Folder Structure

```
MedBook
├── Database Manager   Local Storage
├── Models             # Data models (User, Book, Country)
├── ViewModels         # Business logic and data binding (SignupViewModel, HomeViewModel)
├── Views              # UI and view controllers (LandingViewController, SignupViewController)
├── Services           # Network (APIService)
└── Resources          # Assets, launch screen, etc.
```

## API References

1. **Countries API**: Provides a list of countries for the signup screen.
   - **Endpoint**: `https://api.first.org/data/v1/countries`

2. **Books Search API**: Allows users to search for books by title.
   - **Endpoint**: `https://openlibrary.org/search.json`
   - **Query Parameters**:
      - `title` – Book title search query.
      - `limit` – Limits the number of results per request.

3. **Cover Image API**: Retrieves book cover images based on `cover_i` from the search API.
   - **Endpoint**: `https://covers.openlibrary.org/b/id/<cover_i>-M.jpg`

## Acknowledgements
- OpenLibrary for the book search API
- First.org for the country list API
- Inspired by clean architecture and MVVM design principles
