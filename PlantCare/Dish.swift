//
//  Dish.swift
//  PlantCare
//
//  Created by Taimoor  on 24/04/2023.
//

struct Dish: Codable, Hashable, Identifiable {
  var id: Int
  var name: String
  var cuisine: String
  var price: Int
  var imageName: String
}
