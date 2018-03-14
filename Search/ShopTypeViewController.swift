//
//  ShopTypeViewController.swift
//  MyApp
//
//  Created by SolaMacMini4 on 13/3/18.
//  Copyright © 2018 yonathan. All rights reserved.
//

import UIKit
import Foundation

class ShopTypeViewController : UIViewController {
    
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var shopType = [ShopType]()
    
    var shopTypeFiltered = [ShopType]()
    
    var delegate : ShopTypeDelegate?
    
    override func viewDidLoad() {
        setupView()
    }
    
    private func setupView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let rightBtn = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(doReset))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        shopType.append(ShopType(name: "Gold Merchant"))
        shopType.append(ShopType(name: "Official Store"))
        tableView.tableFooterView = UIView()
        
        if shopTypeFiltered.count != 0 {
            print("BEKAS SBLMNYA")
            for item in shopTypeFiltered {
                if item.name == "Gold Merchant" && item.selected{
                    shopType[0].selected = true
                }
                
                if item.name == "Official Store" && item.selected{
                    shopType[1].selected = true
                }
            }
        }
    }
    
    @IBAction func applyBtnSubmit(_ sender: Any) {
        print("APPLY btn submit : ")
        
        var shopTypeFilter = [ShopType]()
        
        for item in shopType {
            if item.selected {
                shopTypeFilter.append(item)
            }
        }

        self.navigationController?.popViewController(animated: true)
        delegate?.filterShop(shop: shopTypeFilter)
    }
    
    func doReset(){
        for item in shopType {
            item.selected = false
        }
        
        tableView.reloadData()
    }
}

extension ShopTypeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shopType[indexPath.row].name
        cell.selectionStyle = .none
        
        if shopType[indexPath.row].selected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        
        if shopType[indexPath.row].selected == true {
            cell?.accessoryType = .none
            shopType[indexPath.row].selected = false
        } else {
            cell?.accessoryType = .checkmark
            shopType[indexPath.row].selected = true
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        
        if shopType[indexPath.row].selected == true {
            cell?.accessoryType = .none
            shopType[indexPath.row].selected = false
        } else {
            cell?.accessoryType = .checkmark
            shopType[indexPath.row].selected = true
        }
    }
    
}

protocol ShopTypeDelegate {
    func filterShop(shop : [ShopType])
}
