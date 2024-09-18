# Music App Integration Tests 

This Flutter application allows users to explore music, search for artists, view top albums, and manage their favorite albums. The repo also includes integration tests to ensure that core functionalities, like searching for artists and managing favorites, work correctly.

## Tests Include for following screens
- Home Screen 
- Search Albums/Artists
- Favourite and Unfavourites albums

## Prerequisites

- Flutter SDK: 3.19.6. [Flutter Installation Guide](https://docs.flutter.dev/release/archive)
- Git: [Git Installation Guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- Xcode( iOS simulator)
- Android Studio(Android emulator )

## Installation

- Clone the Repository:
   ```bash
   git clone git@github.com:AttiaMinAllah/music-app-integration-tests.git
   
   cd music-app


- Install Doendencies:
    ```bash
    flutter pub get

- Generate required mock file
    ```bash
    flutter pub run build_runner build

- Run the tests
```bash
- Run All integration tests:

    flutter test integration_test

- Run specific Integration tests

    flutter test integration_test/<test_file_name>.dart









