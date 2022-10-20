//
//  Api.swift
//  Meditech
//
//  Created by shomil on 26/08/22.
//

import Foundation

//AppError enum which shows all possible errors
enum AppError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
}

//Result enum to show success or failure
enum Result<T> {
    case success(T)
    case failure(AppError)
    case error(Error?)
}

class ApiCall : NSObject {
    let constValueField = "application/json"
    let constHeaderField = "Content-Type"
    let constantApiKey = "X-CSCAPI-KEY"
    let constantApiKeyValue = "aEJZRmxuTHhHQ25PemZld1ZjTGlWajdkZ2lib0tYd3EwZ2FLY09MWA=="
    
    var observationLoaderView: NSKeyValueObservation?

    //dataRequest which sends request to given URL and convert to Decodable Object
    func dataRequest<T: Decodable>(with url: String, objectType: T.Type , isLoader : Bool = true , loaderInView : UIView? = nil, isErrorToast : Bool = true , completion: @escaping (Result<T>) -> Void) {
        
        guard case ConnectionCheck.isConnectedToNetwork() = true else {
            UIApplication.topViewController()?.view.makeToast(AlertMessage.networkConnection)
            let userInfo: [String : Any] =
                        [ NSLocalizedDescriptionKey :  NSLocalizedString("error", value: AlertMessage.networkConnection, comment: "") ,
                          NSLocalizedFailureReasonErrorKey : NSLocalizedString("error", value: AlertMessage.networkConnection, comment: "")]
            mainThread { completion(.error(NSError(domain: "Builderfly", code: 502, userInfo: userInfo))) }
            return
        }
        var loaderView : UIView?
        if isLoader {
            if var view = loaderInView {
                self.addLoaderInView(&view, loaderView:&loaderView)
            } else {
                Utility().showLoader()
            }
        }
        //create the url with NSURL
        let dataURL = URL(string: url) //change the url

        let method = "GET"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method as String
        request.setValue(constValueField, forHTTPHeaderField: constHeaderField)
        request.setValue(constantApiKeyValue, forHTTPHeaderField: constantApiKey)
        
        //create dataTask using the session object to send data to the server
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with : request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            delayWithSeconds(0.1) {
                if let loaderView = loaderView {
                    mainThread { loaderView.removeFromSuperview() }
                } else {
                    Utility().hideLoader()
                }
            }
            
            guard error == nil else {
                completion(Result.failure(AppError.networkError(error!)))
                return
            }
            
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            do {
                //create decodable object from data
                print(data.description)
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completion(Result.success(decodedObject))
            } catch let error {
                UIApplication.topViewController()?.view.makeToast(error.localizedDescription)
                completion(Result.failure(AppError.jsonParsingError(error as! DecodingError)))
            }
        })
        
        task.resume()
    }
    
    func addLoaderInView(_ view: inout UIView, loaderView : inout UIView?) {
        loaderView = UIView(frame: view.bounds)
        loaderView?.backgroundColor = getBGColor(view)
        let activityIndicator = UIActivityIndicatorView()
        if view.h < 100 || view.w < 100 {
            if #available(iOS 13.0, *) {
                activityIndicator.style = .medium
            } else {
                // Fallback on earlier versions
            }
        } else {
            if #available(iOS 13.0, *) {
                activityIndicator.style = .large
            } else {
                // Fallback on earlier versions
            }
        }
        
        activityIndicator.color = .lightGray
        activityIndicator.startAnimating()
        loaderView?.addSubview(activityIndicator)
        activityIndicator.anchorCenterSuperview()
        view.addSubview(loaderView!)
        observationLoaderView = view.observe(\UIView.frame, options: .new) { [weak loaderView] view, change in
            print("I'm now called \(view.bounds)")
            if let value =  change.newValue {
                loaderView?.frame = value
            }
        }
//        loaderView?.anchorCenterSuperview()
        //                loaderView?.fillToSuperview()
    }
    func getBGColor(_ view : UIView?) -> UIColor {
        guard let view = view  else {
            return .white
        }
        guard let bgColor = view.backgroundColor else {
            return getBGColor(view.superview)
        }
        return bgColor == .clear ? getBGColor(view.superview) : (bgColor.rgba.alpha == 1 ? bgColor : bgColor.withAlphaComponent(1))
    }
}
