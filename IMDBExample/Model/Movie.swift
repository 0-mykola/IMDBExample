//
//  Movie.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import Foundation

class Movie: Codable, Identifiable {
  let id: String
  let rank, title, fullTitle: String?
  let year: String?
  let image: String?
  let crew, imDBRating, imDBRatingCount: String?
  
  var titleData: Title?
  
  enum CodingKeys: String, CodingKey {
    case id, rank, title, fullTitle, year, image, crew
    case imDBRating = "imDbRating"
    case imDBRatingCount = "imDbRatingCount"
    
    case titleData
  }
}
