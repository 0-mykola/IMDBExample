//
//  MovieDetailViewModel.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 01.11.2022.
//

import Foundation

class MovieDetailViewModel: ObservableObject, Identifiable {
  @Published var item: Title?

  private let repository: MoviesDataRepository
  
  init(titleId: String, repository: MoviesDataRepository) {
    self.repository = repository
    
    repository.$title
      .receive(on: DispatchQueue.main)
      .assign(to: &$item)

    repository.fetchTitle(id: titleId)
  }
}
