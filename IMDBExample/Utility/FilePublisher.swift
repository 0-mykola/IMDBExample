//
//  File.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import Foundation
import Combine

class FileSubscription<S: Subscriber>: Subscription where S.Input == Data, S.Failure == Error {
  private let fileURL: URL
  private var subscriber: S?
  
  init(fileURL: URL, subscriber: S) {
    self.fileURL = fileURL
    self.subscriber = subscriber
  }
  
  func request(_ demand: Subscribers.Demand) {
    if demand > 0 {
      do {
        let data = try Data(contentsOf: fileURL)
        subscriber?.receive(data)
        subscriber?.receive(completion: .finished)
      }
      catch let error {
        subscriber?.receive(
          completion: .failure(error)
        )
      }
    }
  }
  
  func cancel() {
    subscriber = nil
  }
}


struct FilePublisher: Publisher {
  typealias Output = Data
  typealias Failure = Error

  let fileURL: URL
  
  func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
    let subscription = FileSubscription(
      fileURL: fileURL,
      subscriber: subscriber
    )
    
    subscriber.receive(subscription: subscription)
  }
}
