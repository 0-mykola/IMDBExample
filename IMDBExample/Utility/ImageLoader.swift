//
//  ImageLoader.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import Foundation
import Combine
import UIKit

final class ImageLoader: ObservableObject {

  final class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    func imageForKey(_ key: String) -> UIImage? {
      cache.object(forKey: NSString(string: key))
    }
    
    func setImageForKey(_ key: String, image: UIImage) {
      cache.setObject(image, forKey: NSString(string: key))
    }
  }
  

  @Published var image: UIImage?
  
  private let imageCache = ImageCache.shared
  private let urlString: String?
  private let errorImage: UIImage?
  private let retries: Int
  
  init(urlString: String?,
       errorImage: UIImage?, retries: Int = 1) {
    self.urlString = urlString
    self.errorImage = errorImage
    self.retries = retries
    self.load()
  }
}

private
extension ImageLoader {
  func load() {
    guard !loadImageFromCache() else { return }
    loadImageFromURL()
  }
  
  func loadImageFromCache() -> Bool {
    guard let urlString = urlString,
          let cacheImage = imageCache.imageForKey(urlString)
    else { return false }
    image = cacheImage
    return true
  }
  
  func loadImageFromURL() {
    guard let urlString = urlString, let url = URL(string: urlString) else { return }
    let request = URLRequest(url: url)

    URLSession.shared.dataTaskPublisher(for: request)
      .tryMap {
        guard let response = $0.response as? HTTPURLResponse,
              response.statusCode == 200,
              let image = UIImage(data: $0.data)
        else {
          throw APIError.responseUnsuccessful
        }
        self.imageCache.setImageForKey(urlString, image: image)
        return image
      }
      .retry(retries)
      .replaceError(with: errorImage)
      .receive(on: DispatchQueue.main)
      .assign(to: &$image)
  }
}
