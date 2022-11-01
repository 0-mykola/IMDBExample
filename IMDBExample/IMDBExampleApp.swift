//
//  IMDBExampleApp.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import SwiftUI

@main
struct IMDBExampleApp: App {
  private var repository = MoviesDataRepository()
  
  var body: some Scene {
    WindowGroup {
      MovieListView(viewModel: MovieListViewModel(repository: repository))
    }
  }
}
