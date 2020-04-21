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

## RxSwift, RxCocoa, RxDataSource and Action:
* Since, I am using MVVM. This pattern works well with Reactive-Programming style.
* RxSwift and RxCocoa helps with data binding
* RxDataSource helps with collection binding
* Action handles API calls, disables UIControl on while executing, return errors and maintains observable sreams

## Some Best Practises:
* Network Layer:
 1. I created a Router to get and manage the API URL
 ```
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
 
 2. I created a wrapper for Alamofire to works with RxSwift. With this i can subscribe for result or error whenever I want.
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
