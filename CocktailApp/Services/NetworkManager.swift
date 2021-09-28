//
//  NetworkManager.swift
//  CocktailApp
//
//  Created by Николай on 25.09.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchData(cocktailName: String, completionHandler: @escaping (Cocktail, Data?) -> Void) {
        
        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=" + cocktailName
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            var cocktails: [Cocktail] = []
            
            do {
                cocktails = try JSONDecoder().decode(CocktailsData.self, from: data).drinks ?? []
            } catch let error {
                print(error.localizedDescription)
            }
            
            guard let cocktail = cocktails.first else {
                return
            }
            
            guard let url = URL(string: cocktail.strDrinkThumb ?? ""),
                let imageData = try? Data(contentsOf: url) else {
                
                DispatchQueue.main.async {
                    completionHandler(cocktail, nil)
                }
                return
            }
                
            DispatchQueue.main.async {
                completionHandler(cocktail, imageData)
            }
            
        }.resume()
        
    }
        
    private init() { }
    
}
