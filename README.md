## Summary
Karros's Coding Challenge
Interviewee: Hoang Lu
Email: tyler.lu1401@gmail.com

## Prerequisites
* XCode 11.3.
* Cocoapods 1.9.1. Run `sudo gem install cocoapods`.
* iOS Deployment target: 13.2

## Usage
1. Open Terminal, navigate to project foler, run command `pod install`
2. Open project in XCode. Make sure you open file karros-video.xcworkspace, not karros-video.xcodeproj
3. Run the project on simulator

## Dependencies
* All dependencies are installed via cocoapods for easy update
  * 'RxSwift'
  * 'RxCocoa'
  * 'RxDataSources' 
  * 'ObjectMapper'
  * 'Alamofire'
  * 'AlamofireImage'
  * 'SnapKit'
  * 'Action' 

Features
=======

## Design Pattern
 ### MVVM
 * MVVM is the base of this whole project.
 * Why MVVM?
  * I need an architecture to seperate UIs and Logic codes
  * MVVM works with this kind of project size 
  * MVVM is my most familiar architecture
 
 * How MVVM is implemented?
  * I have a set of base view controllers and base view model to subclass from

```swift
//Base View Controllers
class BaseViewController<VM: GenericViewModel> { }
class BaseCollectionViewController<VM: GenericListViewModel> { }
class BaseTableViewController<VM: GenericListViewModel> { }

//Base View Models 
class BaseViewModel: { }
class ListViewModel: { }
```
  * So, `BaseCollectionViewController` and `BaseTableViewController` consist a list view model of type `ListViewModel`
  * And, `BaseViewController` consists a view model of type `BaseViewModel`
  * The only job left is to subclass and reuse. I can forget about tableView and collectionView delegates.
 
 ### Other Patters:
 * Singletons for shared resources: Scheduler, DependencyManager
 * Factory to manage fonts

## RxSwift, RxCocoa, RxDataSource and Action:
* Since, I am using MVVM. This pattern works well with Reactive-Programming style.
* RxSwift and RxCocoa helps with data binding
* RxDataSource helps with collection binding
* Action handles API calls, disables UIControl on while executing, return errors and maintains observable sreams

## Some Best Practises:
### Network Layer:
 1. I created a Router to get and manage the API URL
 ```swift
 // ImdbRouter.swift
 enum ImdbRouter: URLRequestConvertible {
    static let baseURLString = "https://api.themoviedb.org/3/movie/"
    static let apiKey = "a7b3c9975791294647265c71224a88ad"
    
    case getNowPlaying(page: Int)
    case getPopular(page: Int)
    case getTopRated(page: Int)
    case getUpcoming(page: Int)
    case getMovieDetail(id: Int)
    case getCredits(id: Int)
    case getReccomends(fromId: Int, page: Int)
    case getReviews(id: Int, page: Int)
    //...
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.method = .get
        return try URLEncoding.queryString.encode(request, with: parameters)
    }
 }
 ```
 
 2. I created a wrapper for Alamofire to works with RxSwift. With this i can subscribe for result or error whenever I want.  This runs on background scheduler by default to avoid freezing UIs while requesting for data
 ```swift 
 //  ImdbService.swift
 func request(urlRequest: URLRequestConvertible) -> Single<[String:Any]> {
        return Single<[String:Any]>.create{ single in
            let request = self.networkManager.alamofireSession.request(urlRequest)
            request.responseJSON{ response in
                if let error = response.error {
                    single(.error(error))
                }
                
                switch response.result {
                case .failure(let error):
                    single(.error(error))
                case .success(let json):
                    guard let json = json as? [String:Any] else {
                        single(.error(ServiceError.cannotParseData))
                        break
                    }
                    single(.success(json))
                }
            }
            
            return Disposables.create{ request.cancel() }
        }
        .subscribeOn(scheduler.backgroundScheduler)
 ```
 3. Image download and image cache. Below is the image cache configuration (50MB on RAM, 100MB on disk).
 ```swift
 //  ImageService.swift
 let imgCache = AutoPurgingImageCache(
     memoryCapacity: 50_000_000,
     preferredMemoryUsageAfterPurge: 20_000_000
 )  
 let diskCache =  URLCache(
     memoryCapacity: 0,
     diskCapacity: 100 * 1024 * 1024,
     diskPath: "alamofireimage_disk_cache"
 }
 ```
 I also created a struct called `NetworkImage` to support easy binding. Later on, all I have to do is create a NetworkImage with the desire url and bind that to UIImageView just like this
 ```swift
 //  MovieCell.swift    
 let posterImage = BehaviorRelay<NetworkImage?>(value: nil)
 posterImage.accept(NetworkImage(model.getPosterImageURL(size: .w342), placeholder: #imageLiteral(resourceName: "ic_image_placeholder")))
 //Bind to imageView
 posterImage.filterNil()
    .bind(to: imgPoster.rx.networkImage)
    .disposed(by: disposeBag)
 ```
 All the download and cache will be handled automatically. `NetworkImage` also supports image placeholder in case the image cannot be donwloaded
 
 4. Imdb poster, profile image, backdrop vary in different sizes. Why not support it all?
 ```swift
 //  Movie.swift
 let baseImageURL = URL(string: "https://image.tmdb.org/t/p/")!
 enum PosterSize: String {
    case w92 = "w92"
    case w154 = "w154"
    case w185 = "w185"
    case w342 = "w342"
    case w500 = "w500"
    case w780 = "w780"
    case original = "original"
 }
 func getPosterImageURL(size: PosterSize) -> URL { }
 ```

### Dependency injection:
 * With a simple implementation of `DependencyManager`, I can inject network service on any class. For example, 
 ```swift
   //  CategoryCell.swift
   let service: IImdbService
   init(category: Category, service: IImdbService = dependencyManager.getService()) {
        self.service = service
        self.category.accept(category)
   }
 ```
 * This may help in case I want to unit-test or run mockup APIs on the scale of whole project

### UIs in codes:
* I prefer having my UI elementes written in codes not storyboard because merging Storyboard codes is not for human.
* SnapKit supports me well on laying out and constraints UI elements
* I found it's faster to  code my UIs than dragging and droppping to storyboard.

### Memory management:
* For me, memory management is the most important part when it comes to mobile application.
* CollectionView and TableView should release resources (mostly images) at the right time to keep memory compsumption to the lowest
* Since RxSwift is in user. Memory leak could be a problem. When any viewcontroller is dismissed, I have to make sure its instance is deallocated.

### Load more and pull to refresh:
* Simple swift down to the end of each row to load more movies.
* Pull to refresh is best to test by: open the app without internet, you will see an empty movie list, connect to the internet and pull to refresh.

