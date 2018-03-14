//
//  ViewController.swift
//  MyApp
//
//  Created by SolaMacMini4 on 12/3/18.
//  Copyright © 2018 yonathan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import Kingfisher

class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FilterProtocol {
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var items = [Data]()
    //let items = ["bang", "radit", "gokil", "bgt", "a", "s", "d", "f", "g"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        print("VIEW DID LOAD SEARCH TERPGL")

        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupView()
        fetchData()
    }
    
    @IBAction func filterBtnClick(_ sender: Any) {
        print("CLICK")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterVC") as! FilterViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupView(){
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width : (self.view.frame.size.width/2) - 6, height: (self.view.frame.size.height/2))
    }
    
    private func fetchData(){
        
        Alamofire.request(Constant.BASE_URL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<Object>) in

            let result = response.result.value
            
            print("RESPONSE : ", result?.status ?? "FAILED")

            guard let itemList = result?.data else {return}
            
            self.items = itemList
            self.collectionView.reloadData()
            
            //print("WHOLE SALE PRICE : ", itemList[0].wholeSalePrice![0].countMax ?? "a")
            //print("WHOLE SALE PRICE INDEX 2 : ", itemList[1].wholeSalePrice?.count ?? "a")
            
            for item in itemList {
                for wholeSale in item.badges! {
                    print("HOPEFULLY I GET IT : ", wholeSale.title ?? "a")
                }
                
                for wholeSale in item.labels! {
                    print("HOPEFULLY I GET IT : ", wholeSale.title ?? "a")
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        
        cell.nameLabel.text = items[indexPath.row].name
        cell.priceLabel.text = items[indexPath.row].price
    
        if let url = items[indexPath.row].imageUrl {
            let imageUrl = URL(string: url)
            cell.productImage.kf.setImage(with: imageUrl)
        }
        
        return cell
    }
    
    func filterData(minPrice: Int, maxPrice: CGFloat, wholeSaleFlag: Bool, shopType: String) {
        print("DATA FROM FILTER : ",minPrice)
        print("DATA FROM FILTER : ",maxPrice)
        print("DATA FROM FILTER : ",wholeSaleFlag)
        print("DATA FROM FILTER : ",shopType)
    }
}


