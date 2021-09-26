//
//  IngredientsViewController.swift
//  CocktailApp
//
//  Created by Николай on 26.09.2021.
//

import UIKit

class IngredientsViewController: UITableViewController {

    var ingredients: [Ingredient] = []
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        var content = cell.defaultContentConfiguration()

        content.image = UIImage(systemName: "star")
        content.text = ingredients[indexPath.row].name
        content.secondaryText = ingredients[indexPath.row].measure

        content.imageProperties.tintColor = .systemPink

        cell.contentConfiguration = content
        
        return cell
    }

}
