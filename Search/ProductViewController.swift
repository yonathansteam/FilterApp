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

class ProductViewController: UIViewController, FilterProtocol {
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var items = [Data]()
    
    var resetItem = [Data]() //ALL NEW ITEM
    var emptyItem = [Data]() //EMPTY ARRAY
    //let items = ["bang", "radit", "gokil", "bgt", "a", "s", "d", "f", "g"]
    
    //LAST FILTER DATA
    var lfWholeSaleFlag  = false
    var lfGoldMerchantFlag = false
    var lfOfficalStoreFlag = false
    var lfMinPrice = 10000
    var lfMaxPrice = 100000
    var lfShopType = [ShopType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        print("VIEW DID LOAD LIST TERPGL")

        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupView()
        fetchData()
    }
    
    @IBAction func filterBtnClick(_ sender: Any) {
        print("CLICK")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterVC") as! FilterViewController
        vc.wholeSaleFlag = lfWholeSaleFlag
        vc.minPrice = lfMinPrice
        vc.maxPrice = lfMaxPrice
        vc.goldMerchantFlag = lfGoldMerchantFlag
        vc.officalStoreFlag = lfOfficalStoreFlag
        vc.shopType = lfShopType
        
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupView(){
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    private func fetchData(){
        
        Alamofire.request(Constant.BASE_URL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<Object>) in

            let result = response.result.value
            
            print("RESPONSE : ", result?.status?.message ?? "FAILED")

            guard let itemList = result?.data else {return}
            
            self.items = itemList
            self.resetItem = itemList
            self.collectionView.reloadData()
        }
    }

    func filterData(minPrice: Int, maxPrice: Int, wholeSaleFlag: Bool, goldMerchant : Bool, officialStore : Bool, reset : Bool, shopType: [ShopType]) {
        print("DATA FROM FILTER                 : ",minPrice)
        print("DATA FROM FILTER                 : ",maxPrice)
        print("DATA FROM FILTER WHOLESALE       : ",wholeSaleFlag)
        print("DATA FROM FILTER GOLD MERCHANT   : ",goldMerchant)
        print("DATA FROM FILTER OFFICIAL STORE  : ",officialStore)
        print("DATA FROM FILTER RESET           : ",reset)
        
        saveFilterData(minPrice, maxPrice, wholeSaleFlag, goldMerchant, officialStore, shopType)
        
        items = resetItem
        var filteredItem = [Data]()
        
        if reset{
            collectionView.reloadData()
        } else {
            //NEED TO REFACTOR THIS
            if wholeSaleFlag && goldMerchant && officialStore {
                
                for item in self.items {
                    if item.labels != nil && item.badges != nil {
                        var price = item.price
                        price = formatPrice(price!)
                        
                        if let string = price, let productPrice = Int(string){
                            if checkProductPrice(productPrice, minPrice, maxPrice){
                                print("validasi sukses all filter")
                                filteredItem.append(item)
                            } else {
                                print("validasi tidak sesuai filter")
                            }
                        }
                    }
                }
            
            } else if wholeSaleFlag && goldMerchant{
                for item in self.items {
                    if item.labels?.count != 0 {
                        for shop in item.badges! {
                            var price = item.price
                            price = formatPrice(price!)
                            
                            if let string = price, let productPrice = Int(string){
                                print("Int 1 : \(productPrice)")
                                print("Int 2 : \(minPrice)")
                                if checkProductPrice(productPrice, minPrice, maxPrice) && shop.title == "Gold Merchant"{
                                    print("validasi sukses wholesale dan gold merchant")
                                    filteredItem.append(item)
                                } else {
                                    print("validasi tidak sesuai filter")
                                }
                            }
                        }
                    }
                }
            } else if wholeSaleFlag && officialStore{
                for item in self.items {
                    if item.labels?.count != 0 {
                        for shop in item.badges! {
                            var price = item.price
                            price = formatPrice(price!)
                            
                            if let string = price, let productPrice = Int(string){
                                if checkProductPrice(productPrice, minPrice, maxPrice) && shop.title == "Official Store"{
                                    print("validasi sukses wholesale dan official store")
                                    filteredItem.append(item)
                                } else {
                                    print("validasi tidak sesuai filter")
                                }
                            }
                        }
                    }
                }
            } else if goldMerchant && officialStore{
                for item in self.items {
                    if item.labels?.count != 0 {
                        for shop in item.badges! {
                            var price = item.price
                            //print("price : ",price)
                            price = price?[3..<(price?.count)!]
                            //print("price : ",price)
                            price = price?.replace(target: ".", withString: "")
                            //print("price : ",price)
                            
                            if let string = price, let productPrice = Int(string){
                                if checkProductPrice(productPrice, minPrice, maxPrice) && shop.title == "Official Store" || shop.title == "Gold Merchant"{
                                    print("validasi sukses gold merchant dan official store")
                                    filteredItem.append(item)
                                } else {
                                    print("validasi tidak sesuai filter")
                                }
                            }
                        }
                    }
                }
            } else if wholeSaleFlag {
                for item in self.items {
                    if item.labels?.count != 0 {
                        for shop in item.labels! {
                            var price = item.price
                            price = formatPrice(price!)
                            
                            if let string = price, let productPrice = Int(string){
                                if checkProductPrice(productPrice, minPrice, maxPrice) && shop.title == "Grosir"{
                                    print("validasi sukses wholesale")
                                    filteredItem.append(item)
                                } else {
                                    print("validasi tidak sesuai filter")
                                }
                            }
                        }
                    }
                }
            } else if goldMerchant {
                for item in self.items {
                    if item.labels?.count != 0 {
                        for shop in item.badges! {
                            var price = item.price
                            price = formatPrice(price!)
                            if let string = price, let productPrice = Int(string){
                                if checkProductPrice(productPrice, minPrice, maxPrice) && shop.title == "Gold Merchant"{
                                    print("validasi sukses gold merchant")
                                    filteredItem.append(item)
                                } else {
                                    print("validasi tidak sesuai filter")
                                }
                            }
                        }
                    }
                }
            } else if officialStore {
                for item in self.items {
                    if item.labels?.count != 0 {
                        for shop in item.badges! {
                            var price = item.price
                            price = formatPrice(price!)
                            if let string = price, let productPrice = Int(string){
                                if checkProductPrice(productPrice, minPrice, maxPrice) && shop.title == "Official Store"{
                                    print("validasi sukses official store")
                                    filteredItem.append(item)
                                } else {
                                    print("validasi tidak sesuai filter")
                                }
                            }
                        }
                    }
                }
            } else {
                for item in self.items {
                    var price = item.price
                    price = formatPrice(price!)
                    if let string = price, let productPrice = Int(string){
                        if checkProductPrice(productPrice, minPrice, maxPrice){
                            print("validasi sukses price only")
                            filteredItem.append(item)
                        } else {
                            print("validasi tidak sesuai filter")
                        }
                    }
                }
            }
        }
        
        if filteredItem.count == 0 && !reset{ //FOR FILTER THAT EMPTY
            print("Filter result zero")
            self.items = emptyItem
            collectionView.reloadData()
        } else if filteredItem.count > 0 && !reset{ // FOR FILTER THAT SUCCESS
            print("Filter result not zero")
            self.items = filteredItem
            collectionView.reloadData()
        }
    }
    
    func formatPrice(_ stringPrice : String) -> String{
        var newPrice = stringPrice[3..<(stringPrice.count)]
        newPrice = newPrice.replace(target: ".", withString: "")
        return newPrice
    }
    
    func checkProductPrice(_ productPrice: Int, _ minPrice: Int, _ maxPrice: Int) -> Bool{
        if productPrice >= minPrice && productPrice <= maxPrice {
            return true
        } else {
            return false
        }
    }
    
    func handleNoFoundData(){
        items = emptyItem
        collectionView.reloadData()
    }
    
    func saveFilterData(_ minPrice: Int,_ maxPrice: Int,_ wholeSaleFlag: Bool,_ goldMerchant : Bool,_ officialStore : Bool, _ shopType : [ShopType]){
        self.lfMinPrice = minPrice
        self.lfMaxPrice = maxPrice
        self.lfWholeSaleFlag = wholeSaleFlag
        self.lfGoldMerchantFlag = goldMerchant
        self.lfOfficalStoreFlag = officialStore
        self.lfShopType = shopType
    }
}

extension ProductViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0.5
        layout.minimumLineSpacing = 5.0
        
        let numberOfItemPerRow: CGFloat = 2.0
        let itemWidth = (collectionView.bounds.width - layout.minimumLineSpacing) / numberOfItemPerRow
        return CGSize(width : itemWidth, height: (self.view.frame.size.height/2))
    }
}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: range.lowerBound)
        let idx2 = index(startIndex, offsetBy: range.upperBound)
        return String(self[idx1..<idx2])
    }
    var count: Int { return characters.count }
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
