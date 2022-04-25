//
//  Extensions.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import Foundation
import UIKit


//MARK: UIImageView
extension UIImageView {
    
    func enableZoom() {
      let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
      isUserInteractionEnabled = true
      addGestureRecognizer(pinchGesture)
    }

    @objc
    private func startZooming(_ sender: UIPinchGestureRecognizer) {
      let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
      guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
      sender.view?.transform = scale
      sender.scale = 1
    }
    
    // this function takes a stringURL and uses it to download an image
    // and uses the returned data to either display a place holder image or the downloaded image itself 
    func setImageFromDownloadURL(from stringURL : String) {
        guard let url = URL(string: stringURL) else {return}
        DispatchQueue.global(qos: .userInitiated).async {
            self.downloadImage(from: url) {[weak self] data, err in
                guard let self = self else {return}
                if let _ = err {
                    // there was an error while retrieving the image data
                    // will set image to place holder image
                    // move to main queue to update ui
                    DispatchQueue.main.async {
                        self.removeActivityIndicator()
                        self.image = UIImage(systemName: "person.circle")
                    }
                }
                guard let imageData = data else {
                    // data came back nill
                    // will set image to placeholder image
                    // move to main queue to update ui
                    DispatchQueue.main.async {
                        self.removeActivityIndicator()
                        self.image = UIImage(systemName: "person.circle")
                    }
                    return
                }
                // move to main queue to update ImageView
                DispatchQueue.main.async {
                    // got image data successfully
                    self.image = UIImage(data: imageData)
                    self.removeActivityIndicator()
                    
                }
            }
        }
            
        
        
    }
    
    private func downloadImage(from url : URL , completion : @escaping (Data? , ServiceError?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, err in
            
            if let err = err {
                completion(nil , ServiceError(httpsStatus: (response as? HTTPURLResponse)?.statusCode ?? 404 , errorMessage: "Failed to get image date with error : \(err)"))
            }
            guard let imageDate = data else {
                completion(nil, ServiceError(httpsStatus: (response as? HTTPURLResponse)?.statusCode ?? 404, errorMessage: "data was nil , Error : \(String(describing: err))"))
                return
            }
            completion(imageDate , nil)
            
        }.resume()
    }
}
 

//MARK: UIView

extension UIView {
    func addActivityIndicator() {
        
        
        
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            
            activityIndicator.topAnchor.constraint(equalTo: self.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            
        ])
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.tag = 475647
        self.isUserInteractionEnabled = false
        
        
        
        }

        func removeActivityIndicator() {
            if let activityIndicatorView = viewWithTag(475647){
                activityIndicatorView.removeFromSuperview()
            }
            self.isUserInteractionEnabled = true
        }
    
}


//MARK: UIViewController

extension UIViewController {
    
    var windowInterfaceOrientation: UIInterfaceOrientation? {
        return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    }
}


//MARK: Date
extension Date {
    func getStringDateFromTimestamp(from timeStamp : Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateFormat = "MMMM dd yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
