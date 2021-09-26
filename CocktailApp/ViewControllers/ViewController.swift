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
    
    private func setGradient() {
        
        let primaryColor = UIColor(
            red: 210/255,
            green: 109/255,
            blue: 128/255,
            alpha: 1
        )
        
        let secondaryColor = UIColor(
            red: 107/255,
            green: 148/255,
            blue: 230/255,
            alpha: 1
        )
        
        let gradient = CAGradientLayer()
       
        gradient.frame = view.bounds
        gradient.colors = [primaryColor.cgColor, secondaryColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        view.layer.insertSublayer(gradient, at: 0)
        
    }
    
    private func setUpElements(isDataLoading: Bool) {
            
        if isDataLoading {
            self.imageView.alpha = 0
            self.titleLabel.alpha = 0
            self.descriptionLabel.alpha = 0
        } else {
           
            UIView.animate(
                withDuration: 1,
                delay: 0,
                options: .curveLinear) {
                    self.imageView.alpha = 1
                    self.titleLabel.alpha = 1
                    self.descriptionLabel.alpha = 1
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
