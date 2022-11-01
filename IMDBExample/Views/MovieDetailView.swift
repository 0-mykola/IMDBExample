//
//  DetailMovieView.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import SwiftUI
import Combine

struct MovieDetailView: View {
  @ObservedObject var viewModel: MovieDetailViewModel

  init(viewModel: MovieDetailViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      createPosterImage()
      createTitle()
      createOccurrenceString()
      createDescription()
    }.edgesIgnoringSafeArea(.top)
  }
}

private
extension MovieDetailView {
  func createTitle() -> some View {
    return Text(viewModel.item?.title ?? "")
      .font(.system(size: 35, weight: .black, design: .rounded))
      .layoutPriority(1)
      .padding(12)
      .multilineTextAlignment(.leading)
      .lineLimit(nil)
  }
  
  func createOccurrenceString() -> some View {
    return Text(viewModel.item?.getOccurrenceString() ?? "")
      .font(.system(size: 14, weight: .bold))
      .layoutPriority(1)
      .multilineTextAlignment(.leading)
      .lineLimit(nil)
  }
  
  func createPosterImage() -> some View {
    return ImageViewCache(urlString: viewModel.item?.image,
                          errorImage: UIImage(named: "ic_empty_movie"))
    .aspectRatio(contentMode: .fit)
  }
  
  func createDescription() -> some View {
    return Text(viewModel.item?.plot ?? "")
      .font(.system(size: 16, weight: .regular))
      .layoutPriority(1)
      .padding(12)
      .multilineTextAlignment(.leading)
      .lineLimit(nil)
  }
}

