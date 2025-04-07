
# MovieSearch

MovieSearch is an iOS application that allows users to search for movies and view details about them. This README provides information on how to run the project locally, and provides insight into how the projct was built.

## Running the project locally

To run the project locally, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/azimpradhan/MovieSearch.git
    cd MovieSearch
    ```

2. Open the project in Xcode:
    ```sh
    open MovieSearch.xcodeproj
    ```

3. Create a `Secrets.xcconfig` file in the root directory of the project and add your TMDB API key:
    ```sh
    TMDB_API_KEY = <YOUR_API_KEY>
    ```

4. Build and run the project in Xcode by selecting a simulator or a connected device and clicking the "Run" button.

## Project Walkthrough

https://github.com/user-attachments/assets/e314a08a-2a06-465c-8e21-3b1c0f0b3062

## Project Architecture

The project follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Model**: Represents the data that important to the application. In this project, the `Movie` and `MoviePage` structs represent the model.
- **View**: Represents the UI components of the application. In this project, SwiftUI views such as `MovieSearch` and `MovieDetail` represent the view.
- **ViewModel**: Acts as a bridge between the model and the view, handling the presentation logic, and communication with upstream services such as the API Client. In this project, `MovieSearchViewModel` represents the view model.

## Data Model

The data model consists of the following structures:

- `Movie`: Represents a movie with properties such as `title`, `overview`, `voteAverage`, `releaseDateString`, and `posterPath`. The `Movie` model also has computed properties for the formatted release date and image URL.
- `MoviePage`: Represents a page of movies with properties such as `pageNumber`, `results`, `totalPages`, and `totalResults`.

## Image Caching

The project uses the `SDWebImageSwiftUI` library for image caching. This library provides an efficient way to download and cache images asynchronously. The `WebImage` view shares an API similar to Apple's native `AsyncImage` view and is used to display images in the `MovieCell` view and `MovieDetail` view, ensuring that images are cached and loaded efficiently.

### Network usage while scrolling results using AsyncImage
<img width="1271" alt="Screenshot 2025-04-04 at 10 52 11 PM" src="https://github.com/user-attachments/assets/831979e3-021e-4391-8d7b-86661b2d6951" />


### Network usage while scrolling results using SDWebImageSwiftUI

<img width="1275" alt="Screenshot 2025-04-04 at 10 49 51 PM" src="https://github.com/user-attachments/assets/13158e0a-a610-4c5f-b0f4-fd7a72988eae" />


## Unit Testing

The project includes unit tests to ensure the correctness of the code. The tests cover various scenarios, including:

- Testing error handling in `MovieSearchViewModel`.
- Testing the `parseResponse` method in the `MoviePageEndpoint` class for different JSON objects representing a movie page.

To run the unit tests, open the project in Xcode and press `Cmd+U`.

## AI Tools

The project leverages GitHub Copilot to assist with code suggestions and improvements.

### How AI was used in this project

https://github.com/user-attachments/assets/b8f346b1-31c6-4536-9125-65f3327ebe92
