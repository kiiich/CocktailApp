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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private let cocktailsNames = DataManager.cocktailsNames
    private let networkManager = NetworkManager()
    private var currentCocktail: Cocktail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentCocktailIndex = 4
        
        fetchData(cocktailName: cocktailsNames[currentCocktailIndex].1)
        
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(currentCocktailIndex, inComponent: 0, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let ingredientsVc = segue.destination as? IngredientsViewController else { return }
        
        guard let cocktail = currentCocktail else {
            return
        }

        let ingredients = [
            cocktail.strIngredient1 ?? "",
            cocktail.strIngredient2 ?? "",
            cocktail.strIngredient3 ?? "",
            cocktail.strIngredient4 ?? "",
            cocktail.strIngredient5 ?? ""
        ].filter { !$0.isEmpty }
        
        ingredientsVc.ingredients = ingredients
        
    }
    
   private func fetchData(cocktailName: String) {
        
       currentCocktail = nil
       
       setUpElements(isDataLoading: true)
       
        networkManager.fetchData(cocktailName: cocktailName) { cocktail in
            
            guard let cocktail = cocktail else {
                return
            }
            
            self.currentCocktail = cocktail
            
            DispatchQueue.main.async {
                self.titleLabel.text = cocktail.title
                self.descriptionLabel.text = cocktail.strInstructions
            }
            
            self.networkManager.fetchImage(urlString: cocktail.strDrinkThumb ?? "") { image in
               
                guard let image = image else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.setUpElements(isDataLoading: false)
                }
            }
        }
    }
        
    private func setUpElements(isDataLoading: Bool) {
            
        
        
        if isDataLoading {
            imageView.alpha = 0
            titleLabel.alpha = 0
            descriptionLabel.alpha = 0
            indicator.alpha = 1
            indicator.startAnimating()
            navigationItem.rightBarButtonItem?.isEnabled = false
            
        } else {
           
            UIView.animate(
                withDuration: 1,
                delay: 0,
                options: .curveLinear) {
                    self.imageView.alpha = 1
                    self.titleLabel.alpha = 1
                    self.descriptionLabel.alpha = 1
                    self.indicator.alpha = 0
                    self.indicator.stopAnimating()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
        }
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
        cocktailsNames[row].0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fetchData(cocktailName: cocktailsNames[row].1)
    }
    
}
