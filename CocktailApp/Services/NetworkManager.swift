//
//  NetworkManager.swift
//  CocktailApp
//
//  Created by Николай on 25.09.2021.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchData(cocktailName: String, completionHandler: @escaping (Cocktail?) -> Void) {
        
        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=" + cocktailName
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let cocktails = try JSONDecoder().decode(CocktailsData.self, from: data).drinks ?? []
                
                if cocktails.isEmpty {
                    return
                }
                
                let cocktail = cocktails[0]
                
                completionHandler(cocktail)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchImage(urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        
        if urlString.isEmpty {
            return
        }
        
        guard let urlImage = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: urlImage) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            
            completionHandler(image)
            
        }.resume()
    }
    
    private init() { }
    
}
