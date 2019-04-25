//
//  ViewController.swift
//  POS
//
//  Created by Tayson Nguyen on 2019-04-23.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let cellIdentifier = "Cell"
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var orderTableView: UITableView!
    
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var discountsLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.dataSource = self
        orderTableView.dataSource = self
        menuTableView.delegate = self
        orderTableView.delegate = self
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == menuTableView {
            return viewModel.menuCategoryTitle(section: section)
            
        } else if tableView == orderTableView {
            return viewModel.orderTitle(section: section)
        }
        
        fatalError()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == menuTableView {
            return viewModel.numberOfMenuCategories()
        } else if tableView == orderTableView {
            return 1
        }
        
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == menuTableView {
            return viewModel.numberOfMenuItems(section: section)
            
        } else if tableView == orderTableView {
            return viewModel.numberOfOrderItems(section: section)
        }
        
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        
        if tableView == menuTableView {
            cell.textLabel?.text = viewModel.menuItemName(indexPath: indexPath)
            cell.detailTextLabel?.text = viewModel.menuItemPrice(indexPath: indexPath)
            
        } else if tableView == orderTableView {
            cell.textLabel?.text = viewModel.orderItemName(indexPath: indexPath)
            cell.detailTextLabel?.text = viewModel.orderItemPrice(indexPath: indexPath)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == menuTableView {
            let indexPaths = [viewModel.addItemToOrder(at: indexPath)]
            orderTableView.insertRows(at: indexPaths, with: .automatic)
            // calculate bill totals
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView == menuTableView {
            return .none
        } else if tableView == orderTableView {
            return .delete
        }
        
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == orderTableView && editingStyle == .delete {
            viewModel.removeItemFromOrder(at: indexPath)
            orderTableView.deleteRows(at: [indexPath], with: .automatic)
            // calculate bill totals
        }
    }
}


class ViewModel {
    private struct Category {
        let name: String
        let items: [Item]
    }
    
    private let categories = [
        Category(name: "Appetizers", items: appetizersCategory),
        Category(name: "Mains", items: mainsCategory),
        Category(name: "Drinks", items: drinksCategory),
    ]
    
    var orderItems: [Item] = []
    
    func menuCategoryTitle(section: Int) -> String? {
        return categories[section].name
    }
    
    func orderTitle(section: Int) -> String? {
        return "Order"
    }
    
    func numberOfMenuCategories() -> Int {
        return categories.count
    }
    
    func numberOfMenuItems(section: Int) -> Int {
        return categories[section].items.count
    }
    
    func numberOfOrderItems(section: Int) -> Int {
        return orderItems.count
    }
    
    func menuItemName(indexPath: IndexPath) -> String? {
        return categories[indexPath.section].items[indexPath.row].name
    }
    
    func menuItemPrice(indexPath: IndexPath) -> String? {
        return categories[indexPath.section].items[indexPath.row].priceLabel
    }
    
    func orderItemName(indexPath: IndexPath) -> String? {
        return orderItems[indexPath.row].name
    }
    
    func orderItemPrice(indexPath: IndexPath) -> String? {
        return orderItems[indexPath.row].priceLabel
    }
    
    func addItemToOrder(at indexPath: IndexPath) -> IndexPath {
        let item = categories[indexPath.section].items[indexPath.row]
        orderItems.append(item)
        return IndexPath(row: orderItems.count - 1, section: 0)
    }
    
    func removeItemFromOrder(at indexPath: IndexPath) {
        orderItems.remove(at: indexPath.row)
    }
}
