//
//  CombineAPI.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import Foundation
import Combine

protocol ProviderProtocol {
  var session: URLSession { get }
  
  func request(_ request: Request,
               queue: DispatchQueue) -> AnyPublisher<Data, Error>
  
  func request<T>(_ request: Request,
                  decodingType: T.Type,
                  queue: DispatchQueue) -> AnyPublisher<T, Error> where T: Decodable
}

extension ProviderProtocol {
  func request(_ request: Request,
               queue: DispatchQueue = .main) -> AnyPublisher<Data, Error> {
    return session.dataTaskPublisher(for: request.request)
      .tryMap {
        guard let response = $0.response as? HTTPURLResponse, response.statusCode == 200 else {
          throw APIError.responseUnsuccessful
        }
        return $0.data
      }
      .receive(on: queue)
      .eraseToAnyPublisher()
  }
  
  func request<T>(_ request: Request,
                  decodingType: T.Type,
                  queue: DispatchQueue = .main) -> AnyPublisher<T, Error> where T: Decodable {
    return session.dataTaskPublisher(for: request.request)
      .tryMap {
        guard let response = $0.response as? HTTPURLResponse, response.statusCode == 200 else {
          throw APIError.responseUnsuccessful
        }
        return $0.data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .receive(on: queue)
      .eraseToAnyPublisher()
  }
}
