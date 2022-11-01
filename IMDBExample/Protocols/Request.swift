//
//  Request.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import Foundation

protocol Request {
  var base: String { get }
  var language: String { get }
  var path: String { get }
  var urlComponents: URLComponents { get }
}

extension Request {
  var apiKey: String {
    return APIConstants.IMDBAPIKey
  }
  
  var request: URLRequest {
    let url = urlComponents.url!
    return URLRequest(url: url)
  }
}
