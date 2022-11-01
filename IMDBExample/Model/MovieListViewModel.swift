//
//  MovieListViewModel.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import SwiftUI
import Combine

class MovieListViewModel: ObservableObject, Identifiable {
  @Published var title: String = ""
  @Published var error: Error?
  @Published var dataSource: [Movie] = []
  
  private let repository: MoviesDataRepository

  init(
    repository: MoviesDataRepository,
    scheduler: DispatchQueue = DispatchQueue(label: "MovieListViewModel")
  ) {
    self.repository = repository
    
    repository.$movies.combineLatest($title.debounce(for: .seconds(0.5), scheduler: scheduler))
      .receive(on: DispatchQueue.main)
      .map { items, title -> [Movie] in
        var movies = items
        if !title.isEmpty {
          movies = movies.filter {
            $0.title?.range(of: title, options: .caseInsensitive) != nil
          }
        }
        // prefix(10) is only for a test exercise
        return title.isEmpty ? Array(movies.prefix(10)) : movies
      }
      .assign(to: &$dataSource)
    
    repository.$error
      .receive(on: DispatchQueue.main)
      .assign(to: &$error)
  }
  
  func refreshData() {
    repository.fetchTopMovies()
  }
}

extension MovieListViewModel {
  func getMovieDetailViewModel(id: String) -> MovieDetailViewModel {
    return MovieDetailViewModel(titleId: id, repository: repository)
  }
}
