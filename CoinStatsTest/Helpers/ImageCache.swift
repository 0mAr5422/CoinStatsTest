//
//  ImageCache.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/26/22.
//



// this ImageCache will be used inside of Helpers/Extensions in the UIImageView Extension
// when the setImageFromDownloadURL gets called it will first check for the image in the cache
// if the image is available it will use it without calling the api
// if not the image will be downloaded from the url and then it will be added to the cache 

import UIKit

final class ImageCache {
  static let shared = ImageCache()
  private var images: [String: UIImage] = [:]

  init() {
      // allow the cache to listed to memory warnings sent by the system
    NotificationCenter.default.addObserver(
      forName: UIApplication.didReceiveMemoryWarningNotification,
      object: nil,
      queue: .main) { [weak self] _ in
          print("removing image")
        self?.images.removeAll(keepingCapacity: false)
    }
  }

}

// MARK: - Custom Accessors
extension ImageCache {
  func set(_ image: UIImage, forKey key: String) {
    images[key] = image
  }

  func image(forKey key: String) -> UIImage? {
    return images[key]
  }
}
