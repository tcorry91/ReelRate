# ReelRate 🎬  
ReelRate is an intuitive and visually appealing movie discovery app that allows users to explore popular movies, search for specific titles, and view detailed movie information. The app features a clean UI, optimized performance, and custom design elements to enhance user experience.

## Features 🚀
- **Popular Movies:** Displays a list of trending movies fetched from a live API.
- **Search Functionality:** Allows users to search for specific movies or shows.
- **Detailed Movie View:** Includes movie descriptions, genres, release dates, and user ratings.
- **Favorites Management:** Users can favorite movies for quick access.
- **Dynamic UI Updates:** Smooth transitions and search results handling.

## Technologies Used 🛠️
- **Swift 5**
- **UIKit**
- **Combine Framework**
- **Custom Fonts (Jomhuria, Inter)**
- **TMDb API** for fetching movie data
- **NSCache** for image caching
- **MVC Architecture**

## Installation ⚙️
1. Clone the repository: git clone https://github.com/tcorry91/ReelRate.git  
2. Open ReelRate.xcodeproj in Xcode.
3. Run the project on a simulator or physical device.

How to Use 🧐
1. View Popular Movies: Launch the app to see trending movies on the main screen.
2. Search for Titles: Use the search bar at the top to find specific movies or shows by title.
3. View Movie Details: Tap on a movie to see detailed information like the overview, release date, and genres.
4. Favorite Movies: Save your favorite movies by tapping the heart icon in the detail view.

Future Improvements ✨
Implement user authentication for personalized movie recommendations.
Add user reviews and community ratings.
Improve accessibility and support for dark mode.

API Setup 🔑
ReelRate uses the TMDb API to fetch movie data. You'll need your own API Read Access Token to run the app.

Steps to Set Up Your API Token:
Generate Your API Read Access Token:

Visit The Movie Database (TMDb) and sign up for a free account if you don't have one.
Go to Settings > API and generate an API Read Access Token.
Set Up Your .env File:

In your project directory, create a new .env file if it doesn't already exist.
Add the following line to your .env file: BEARER_TOKEN=YOUR_API_READ_ACCESS_TOKEN

Replace YOUR_API_READ_ACCESS_TOKEN with your actual API Read Access Token.

Run the app:
You're all set! The app will now fetch movie data using your API key.

License 📜
This project is licensed under the MIT License. See the LICENSE file for details.


Made with ❤️ by Timothy Corry


