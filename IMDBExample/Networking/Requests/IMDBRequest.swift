//
//  IMDBRequest.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import Foundation

enum IMDBRequest: Request {
  case top250Movies
  case title(id: String)

  var base: String {
    return "https://imdb-api.com"
  }
  
  var language: String {
    return "en"
  }

  var path: String {
    switch self {
    case .top250Movies: return "Top250Movies"
    case .title: return "Title"
    }
  }
  
  var urlComponents: URLComponents {
    var baseURLPath = [base, language, "API", path, apiKey]
    switch self {
    case .top250Movies:
      break
    case .title(let id):
      baseURLPath.append(id)
    }
    
    let components = URLComponents(string: baseURLPath.slashJoined())!
    return components
  }
}
