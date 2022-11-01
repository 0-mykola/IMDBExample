//
//  IMDBProvider.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import Foundation
import Combine

final class IMDBProvider: ProviderProtocol {
  let session: URLSession
  
  init(configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
  }
  
  convenience init() {
    self.init(configuration: .default)
  }
  
  func get<T: Decodable>(_ request: IMDBRequest) -> AnyPublisher<T, Error> {
    self.request(request, decodingType: T.self)
  }
}
