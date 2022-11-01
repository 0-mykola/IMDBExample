//
//  MovieRow.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import SwiftUI
import Combine

struct MovieRow: View {
  private let item: Movie

  init(item: Movie) {
    self.item = item
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: 20) {
      ImageViewCache(urlString: item.image,
                     errorImage: UIImage(named: "ic_empty_movie")?.resizeWithScaleAspectFitMode(to: 100 * UIScreen.main.nativeScale))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .aspectRatio(contentMode: .fill)
        .frame(width: 100, height: 150)

      VStack(alignment: .leading, spacing: 8.0) {
        Text((item.rank ?? "") + ". " + (item.title ?? "Not available"))
          .font(.system(size: 16, weight: .bold))
        Text(item.fullTitle ?? "Not available")
          .font(.system(size: 12, weight: .regular))
        Text(item.crew ?? "Not available")
          .font(.system(size: 12, weight: .regular))
      }
    }
    .padding(12)
  }
}
