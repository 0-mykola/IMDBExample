//
//  ImageViewCache.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import SwiftUI

struct ImageViewCache: View {
  @ObservedObject var imageLoader: ImageLoader
  
  private let errorImage: UIImage?
  
  init(urlString: String?, errorImage: UIImage?) {
    imageLoader = ImageLoader(urlString: urlString, errorImage: errorImage)
    self.errorImage = errorImage
  }
  
  var body: some View {
    Image(uiImage: imageLoader.image ?? self.errorImage!)
      .resizable()
      .scaledToFill()
  }
}
