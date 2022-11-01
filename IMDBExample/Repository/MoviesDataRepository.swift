//
//  DataStorage.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import Foundation
import Combine

final class MoviesDataRepository {
  static let fileStorage = "movies.json"
  
  var remoteDataSource: MoviesFetchable
  var localDataSource: FilePublisher
  
  @Published var movies: [Movie] = []
  @Published var title: Title?
  @Published var error: Error?
  
  private var disposables = Set<AnyCancellable>()
  
  init(remoteDataSource: MoviesFetchable = MoviesFetcher(with: IMDBProvider()),
       localDataSource: FilePublisher = FilePublisher(fileURL: URL.documents.appendingPathComponent(MoviesDataRepository.fileStorage))) {
    self.remoteDataSource = remoteDataSource
    self.localDataSource = localDataSource
    
    if Storage.fileExists(MoviesDataRepository.fileStorage, in: .documents) {
      localDataSource
        .subscribe(on: DispatchQueue.global(qos: .background))
        .receive(on: DispatchQueue.main)
        .decode(type: [Movie].self, decoder: JSONDecoder())
        .replaceError(with: [])
        .assign(to: &$movies)
    } else {
      fetchTopMovies()
    }
  }
  
  func fetchTopMovies() {
    remoteDataSource.fetchTopMovies()
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          self.error = error
        }
      },receiveValue: saveToStorage(movies:))
      .store(in: &disposables)
  }
  
  func fetchTitle(id: String) {
    if let title = movies.first(where: { $0.id == id })?.titleData {
      self.title = title
    } else {
      self.title = nil
      remoteDataSource.fetchTitle(id: id)
        .sink(receiveCompletion: { completion in
          if case .failure(let error) = completion {
            self.error = error
          }
        },receiveValue: saveToStorage(title:))
        .store(in: &disposables)
    }
  }
}

private
extension MoviesDataRepository {
  func saveToStorage(movies: MoviesResult) {
    Storage.store(movies.items, to: .documents, as: MoviesDataRepository.fileStorage)
    self.movies = movies.items
  }
  
  func saveToStorage(title: Title) {
    if let movie = movies.first(where: { $0.id == title.id }) {
      movie.titleData = title
      Storage.store(movies, to: .documents, as: MoviesDataRepository.fileStorage)
    }
    self.title = title
  }
}
