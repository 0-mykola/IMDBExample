//
//  MovieListView.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import SwiftUI

struct MovieListView: View {
  @ObservedObject var viewModel: MovieListViewModel
  @State private var selectedMovie: Movie?
  
  init(viewModel: MovieListViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    NavigationView {
      List {
        searchField
        if viewModel.dataSource.isEmpty {
          emptySection
        } else {
          moviesSection
        }
      }
      .errorAlert(error: $viewModel.error)
      .refreshable {
        refreshData()
      }
      .navigationBarTitle("Top 250 Movies")
      .sheet(item: $selectedMovie) {
        MovieDetailView(viewModel: viewModel.getMovieDetailViewModel(id: $0.id))
      }
    }.onTapGesture {
      self.endEditing()
    }
  }
}

extension View {
  func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
    let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
    return alert(isPresented: .constant(error.wrappedValue != nil), error: localizedAlertError) { _ in
      Button(buttonTitle) {
        error.wrappedValue = nil
      }
    } message: { error in
      Text(error.errorDescription ?? "Unknown")
    }
  }
}

struct LocalizedAlertError: LocalizedError {
  let underlyingError: LocalizedError
  var errorDescription: String? {
    underlyingError.errorDescription
  }
  var recoverySuggestion: String? {
    underlyingError.recoverySuggestion
  }
  
  init?(error: Error?) {
    guard let localizedError = error as? LocalizedError else { return nil }
    underlyingError = localizedError
  }
}

private extension MovieListView {
  var searchField: some View {
    HStack(alignment: .center) {
      TextField("e.g. The Matrix", text: $viewModel.title)
    }
  }
  
  var moviesSection: some View {
    Section {
      ForEach(viewModel.dataSource) { item in
        MovieRow(item: item).onTapGesture {
          self.selectedMovie = item
        }
      }
    }
  }
  
  var emptySection: some View {
    Section {
      Text("No results")
        .foregroundColor(.gray)
    }
  }
  
  func refreshData() {
    viewModel.refreshData()
  }
  
  func endEditing() {
    UIApplication.shared.endEditing()
  }
}
