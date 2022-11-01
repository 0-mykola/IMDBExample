//
//  MoviesFetcher.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import Foundation
import Combine

protocol MoviesFetchable {
  func fetchTopMovies() -> AnyPublisher<MoviesResult, Error>
  func fetchTitle(id: String) -> AnyPublisher<Title, Error>
}


class MoviesFetcher {
  private let provider: IMDBProvider
  
  init(with provider: IMDBProvider) {
    self.provider = provider
  }
}

extension MoviesFetcher: MoviesFetchable {
  func fetchTopMovies() -> AnyPublisher<MoviesResult, Error> {
    return provider.get(.top250Movies)
  }
  
  func fetchTitle(id: String) -> AnyPublisher<Title, Error> {
    return provider.get(.title(id: id))
  }
}
