# TheMovieManager

iOS client app for [theMovieDB](https://www.themoviedb.org) api. It allows users to login using their theMovieDB credentials.

An authenticated user can **search** for movies, view the movie poster, add to his/her **watchlist** and add to his/her **favorites list**.

## Screenshots
<p>
    <img src="https://raw.githubusercontent.com/djade007/nd-TheMovieManager/master/screenshots/01.png" width="200px" height="auto" hspace="20"/>
    <img src="https://raw.githubusercontent.com/djade007/nd-TheMovieManager/master/screenshots/02.png" width="200px" height="auto" hspace="20"/>
    <img src="https://raw.githubusercontent.com/djade007/nd-TheMovieManager/master/screenshots/03.png" width="200px" height="auto" hspace="20"/>
    <img src="https://raw.githubusercontent.com/djade007/nd-TheMovieManager/master/screenshots/04.png" width="200px" height="auto" hspace="20"/>
</p>

## Implementation
### Main Entry Point into the app
- SceneDelegate.swift file `scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)`
- It determines the appropriate root viewcontroller to display.
- `LoginViewController` if the user is not logged in and the `UITabViewController` if the user is logged in

### Features
- [CoreData](https://developer.apple.com/documentation/coredata): stores user favorite and watchlist movies, implemented in `Services/DataController.swift`
- `Model/TheMovieManager.xcdatamodeld` holds the CoreData model with the following fields,
- `id: Int32` - The movie id
- `title: String` - The title of the movie
- `favorite: Boolean` - Indicates if the movie has been added to favorites list
- `watchlist: Boolean` - Indicates if the movie has been added to watchlist
- `posterPath: String` - The poster image path, which is being resolved in `Constants.swift` to https://image.tmdb.org/t/p/w500/$path
- `releaseDate: Date` - The date the movie was released

* [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults): stores the sessionId credential for theMovieDB API, implemented in `Services/Auth.swift`

- [Alamofire](https://github.com/Alamofire/Alamofire): HTTP networking library
- The router is set up in `Mode/TMDB Client/TMDBRouter.swift`
- The api client is set up in `Mode/TMDB Client/TMDBClient.swift`

* [Kingfisher](https://github.com/onevcat/Kingfisher): library for downloading and caching movie poster images
* Used in `MovieDetailViewController.swift` to load the poster image


##  How to build

- Ensure you have [CocoaPods](https://cocoapods.org/) installed

```bash
pod install
```

- Open `TheMovieManager.xcworkspace` in Xcode

- Update your moviedb API key in `Model/Constants.swift`

- Run the app


## Requirements
- Xcode 12
- Swift 5


## Dependencies
- [CoreData](https://developer.apple.com/documentation/coredata) - for storing user favorite and watchlist movies
- [Alamofire](https://github.com/Alamofire/Alamofire) - for making API networking calls
- [Kingfisher](https://github.com/onevcat/Kingfisher) - for downloading and caching movie poster images


## License
[MIT](https://choosealicense.com/licenses/mit/)
