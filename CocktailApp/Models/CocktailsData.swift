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
    
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    
    var title: String {
        "\(strDrink ?? "") (\(strCategory?.lowercased() ?? ""))"
    }
    
}

struct CocktailsData: Decodable {
    let drinks: [Cocktail]?
}

struct Ingredient {
    let name: String
    let measure: String
}
