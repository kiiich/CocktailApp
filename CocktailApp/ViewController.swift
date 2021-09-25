//
//  ViewController.swift
//  CocktailApp
//
//  Created by Николай on 25.09.2021.
//

import UIKit

class ViewController: UIViewController {
        
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let cocktailsNames = [
        "beer",
        "margarita",
        "rom",
        "vodka",
        "cuba_libra",
        "white_russian",
        "water"
    ]
    
    private var cocktail: Cocktail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentCocktailIndex = 3
        
        fetchData(cocktailName: cocktailsNames[currentCocktailIndex])
        
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(currentCocktailIndex, inComponent: 0, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    private func fetchData(cocktailName: String) {
        
        cocktail = nil
        
        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=" + cocktailName
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let cocktails = try JSONDecoder().decode(DataCocktails.self, from: data).drinks ?? []
                
                if cocktails.isEmpty {
                    return
                }
                
                self.cocktail = cocktails[0]
                
                DispatchQueue.main.async {
                    
                    guard let cocktail = self.cocktail else {
                        return
                    }

                    self.titleLabel.text = cocktail.title
                    self.descriptionLabel.text = cocktail.strInstructions
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
            self.fetchImage(urlString: self.cocktail?.strDrinkThumb ?? "")
            
        }.resume()
    }
    
    private func fetchImage(urlString: String) {
        
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
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
            
        }.resume()
        
    }

}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        cocktailsNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        cocktailsNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fetchData(cocktailName: cocktailsNames[row])
    }
    
}

struct Cocktail: Decodable {
    let strDrink: String?
    let strInstructions: String?
    let strDrinkThumb: String?
    let strCategory: String?
    
    var title: String {
        "\(strDrink ?? "") (\(strCategory?.lowercased() ?? ""))"
    }
    
}

struct DataCocktails: Decodable {
    let drinks: [Cocktail]?
}
