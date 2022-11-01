//
//  Title.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 01.11.2022.
//

import Foundation

struct Title: Codable, Hashable, Identifiable {
  let id: String
  let title, originalTitle, fullTitle: String?
  let type, year: String?
  let image: String?
  let releaseDate, runtimeMins, runtimeStr, plot: String?
  let plotLocal: String?
  let plotLocalIsRTL: Bool?
  let awards, directors: String?
  
  enum CodingKeys: String, CodingKey {
    case id, title, originalTitle, fullTitle, type, year, image, releaseDate, runtimeMins, runtimeStr, plot, plotLocal
    case plotLocalIsRTL = "plotLocalIsRtl"
    case awards, directors
  }
  
  func getOccurrenceString() -> String? {
    guard var title = title else { return nil }
    title = title.replacingOccurrences(of: " ", with: "")
    var d: Dictionary<Character, Int> = [:]
    title.forEach { char in
      if d[char] == nil {
         d[char] = 1
      } else {
        d[char]! += 1
      }
    }
    
    var string = ""
    title.enumerated().forEach {
      if let count = d[$0.element] {
        string += "\($0.element)\(count)"
        d[$0.element] = nil
        
        if $0.offset < title.count - 1 {
          string += " "
        }
      }
    }
    
    return string
  }
}

extension Character {
  func unicodeScalarCodePoint() -> UInt32 {
    let characterString = String(self)
    let scalars = characterString.unicodeScalars
    return scalars[scalars.startIndex].value
  }
}
