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
    
    
    private let cocktailsNames = [
        ("Beer", "beer"),
        ("Margarita", "margarita"),
        ("Rum", "rum"),
        ("Cuba Libra", "cuba_libra"),
        ("Vodka", "vodka"),
        ("White Russian", "white_russian"),
        ("Water", "water")
    ]
    
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentCocktailIndex = 3
        
        fetchData(cocktailName: cocktailsNames[currentCocktailIndex].1)
        
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(currentCocktailIndex, inComponent: 0, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
   private func fetchData(cocktailName: String) {
        
       setUpElements(isDataLoading: true)
       
        networkManager.fetchData(cocktailName: cocktailName) { cocktail in
            
            guard let cocktail = cocktail else {
                return
            }
            
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
            
        titleLabel.isHidden = isDataLoading
        descriptionLabel.isHidden = isDataLoading
        imageView.isHidden = isDataLoading
        indicator.isHidden = !isDataLoading
        
        if isDataLoading {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
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
