//
//  MoviesResult.swift
//  IMDBExample
//
//  Created by Mykola Hordynchuk on 31.10.2022.
//

import Foundation

struct MoviesResult: Decodable {
  let items: [Movie]
}

