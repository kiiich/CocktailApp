//
//  CocktailsData.swift
//  CocktailApp
//
//  Created by Николай on 25.09.2021.
//

import Foundation

struct Cocktail: Decodable {
    
    let strDrink: String?
    let strInstructions: String?
    let strDrinkThumb: String?
    let strCategory: String?
    
    var title: String {
        "\(strDrink ?? "") (\(strCategory?.lowercased() ?? ""))"
    }
    
}

struct CocktailsData: Decodable {
    let drinks: [Cocktail]?
}
