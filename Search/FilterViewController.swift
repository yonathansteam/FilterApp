//
//  FilterViewController.swift
//  MyApp
//
//  Created by SolaMacMini4 on 12/3/18.
//  Copyright © 2018 yonathan. All rights reserved.
//

import UIKit
import RangeSeekSlider

class FilterViewController: UIViewController {
    
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    
    @IBOutlet weak var rangeSeekSlider: RangeSeekSlider!
    @IBOutlet weak var wholeSaleSwitch: UISwitch!
    
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var shopTypeBtn: UIView!
    
    @IBOutlet weak var shopType1Label: UILabel!
    @IBOutlet weak var shopType2Label: UILabel!
    
    @IBOutlet weak var shopType1Btn: UIButton!
    @IBOutlet weak var shopType2Btn: UIButton!
    
    var wholeSaleFlag  = false
    var resetFlag = false
    var goldMerchantFlag = false
    var officalStoreFlag = false
    
    var delegate : FilterProtocol?
    
    var minPrice = 10000
    var maxPrice = 100000
    
    var lfMinPrice : Int?
    var lfMaxPrice : Int?
    
    var shopType = [ShopType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rangeSeekSlider.delegate = self
        wholeSaleSwitch.addTarget(self, action: #selector(switchIsChanged(mySwitch:)), for: UIControlEvents.valueChanged)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(selectShopType))
        shopTypeBtn.addGestureRecognizer(recognizer)
        
        setupView()
        setFromLastFilter()
    }
    
    func setupView(){
        let rightBtn = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(doReset))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    func setFromLastFilter(){
        print("LAST FILTER DATA MIN PRICE       : ",self.minPrice)
        print("LAST FILTER DATA MAX PRICE       : ",self.maxPrice)
        print("LAST FILTER DATA WHOLESALE FLAG  : ",self.wholeSaleFlag)
        print("LAST FILTER DATA GOLD MERCH FLAG : ",self.goldMerchantFlag)
        print("LAST FILTER DATA OFFICIAL STORE  : ",self.officalStoreFlag)
        print("LAST FILTER DATA SHOP TYPE       : ",self.shopType.count)

        if wholeSaleFlag {
            wholeSaleSwitch.setOn(true, animated: false)
        } else {
            wholeSaleSwitch.setOn(false, animated: false)
        }
        
        //LABEL PRICE
        self.maxPrice = Int(maxPrice)
        self.minPrice = Int(minPrice)
        self.minPriceLabel.text = "Rp \(self.minPrice)"
        self.maxPriceLabel.text = "Rp \(self.maxPrice)"
        
        //RANGE SEEK SLIDER
        rangeSeekSlider.selectedMinValue = CGFloat(minPrice)
        rangeSeekSlider.selectedMaxValue = CGFloat(maxPrice)
        
        if (goldMerchantFlag && officalStoreFlag){
            self.shopType1Label.text = "Gold Merchant"
            self.shopType2Label.text = "Official Store"
            
            self.shopType1Btn.setImage(#imageLiteral(resourceName: "ic_clear"), for: .normal)
            self.shopType2Btn.setImage(#imageLiteral(resourceName: "ic_clear"), for: .normal)
            
            self.shopType1Label.textColor = UIColor.black
            self.shopType2Label.textColor = UIColor.black
        } else if goldMerchantFlag {
            self.shopType1Label.text = "Gold Merchant"
            self.shopType1Btn.setImage(#imageLiteral(resourceName: "ic_clear"), for: .normal)
            self.shopType1Label.textColor = UIColor.black
        } else if officalStoreFlag {
            self.shopType1Label.text = "Official Store"
            self.shopType1Btn.setImage(#imageLiteral(resourceName: "ic_clear"), for: .normal)
            self.shopType1Label.textColor = UIColor.black
        }
        
    }
    
    func selectShopType(){
        print("Select shop type")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShopTypeVC") as! ShopTypeViewController
        vc.delegate = self
        vc.shopTypeFiltered = shopType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func doReset(){
        print("RESET")
        resetFlag = true
        wholeSaleFlag = false
        goldMerchantFlag = false
        officalStoreFlag = false
        
        rangeSeekSlider.selectedMinValue = 10000
        rangeSeekSlider.selectedMaxValue = 100000
        
        rangeSeekSlider.minValue = 10000
        rangeSeekSlider.maxValue = 100000
        
        wholeSaleSwitch.setOn(false, animated: true)
        minPriceLabel.text = "Rp 10000"
        maxPriceLabel.text = "Rp 100000"
        
        minPrice = 10000
        maxPrice = 100000
        
        dismissAllShopType()
        clearShopType()
    }
    
    func switchIsChanged(mySwitch: UISwitch) {
        if wholeSaleSwitch.isOn {
            wholeSaleFlag = true
        } else {
            wholeSaleFlag = false
        }
    }
    
    @IBAction func applyBtnSubmit(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        print("RESET FLAG  : ", resetFlag)
        delegate?.filterData(minPrice: minPrice, maxPrice: maxPrice, wholeSaleFlag: wholeSaleFlag, goldMerchant: goldMerchantFlag , officialStore: officalStoreFlag, reset: resetFlag, shopType: shopType)
    }
    
    @IBAction func shopType1Btn(_ sender: Any) {
        clearShopLabel1()
    }
    
    @IBAction func shopType2Btn(_ sender: Any) {
        clearShopLabel2()
    }
    
    func clearShopLabel1(){
        if shopType.count > 0 {
            self.shopType1Label.textColor = UIColor.white
            self.shopType1Btn.setImage(nil, for: .normal)
            self.shopType[0].selected = false
            
            if shopType[0].name == "Gold Merchant"{
                self.goldMerchantFlag = false
            } else if shopType[0].name == "Official Store"{
                self.officalStoreFlag = false
            }
        } else {
            print("SEMOGA GA ADA YG MSK ISNI")
        }
    }
    
    func clearShopLabel2(){
        if shopType.count > 1{
            self.shopType2Label.textColor = UIColor.white
            self.shopType2Btn.setImage(nil, for: .normal)
            self.shopType[1].selected = false
            
            if shopType[1].name == "Gold Merchant"{
                self.goldMerchantFlag = false
            } else if shopType[1].name == "Official Store"{
                self.officalStoreFlag = false
            }
        }
    }
    
    func dismissAllShopType(){
        self.shopType1Label.textColor = UIColor.white
        self.shopType1Btn.setImage(nil, for: .normal)
        
        self.shopType2Label.textColor = UIColor.white
        self.shopType2Btn.setImage(nil, for: .normal)
    }
    
    func clearShopType(){
        if shopType.count == 2 {
            self.shopType[0].selected = false
            self.shopType[1].selected = false
            
            self.goldMerchantFlag = false
            self.officalStoreFlag = false
        } else if shopType.count == 1 {
            self.shopType[0].selected = false
            
            if shopType[0].name == "Gold Merchant"{
                self.goldMerchantFlag = false
            } else {
                self.officalStoreFlag = false
            }
        }
    }
}

extension FilterViewController: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        self.maxPrice = Int(maxValue)
        self.minPrice = Int(minValue)
        self.minPriceLabel.text = "Rp \(self.minPrice)"
        self.maxPriceLabel.text = "Rp \(self.maxPrice)"
    }
}

extension FilterViewController: ShopTypeDelegate {
    func filterShop(shop: [ShopType]) {
        self.shopType = shop
        
        print("SHOP TYPE : ",shop.count)
        
        if shop.count == 2 {
            self.shopType1Label.text = shop[0].name
            self.shopType1Btn.setImage(#imageLiteral(resourceName: "ic_clear"), for: .normal)
            self.shopType1Label.textColor = UIColor.black
            
            self.shopType2Label.text = shop[1].name
            self.shopType2Btn.setImage(#imageLiteral(resourceName: "ic_clear"), for: .normal)
            self.shopType2Label.textColor = UIColor.black
        } else if shop.count == 1 {
            self.shopType1Label.text = shop[0].name
            self.shopType1Btn.setImage(#imageLiteral(resourceName: "ic_clear"), for: .normal)
            self.shopType1Label.textColor = UIColor.black
            
            self.shopType2Label.textColor = UIColor.white
            self.shopType2Btn.setImage(nil, for: .normal)
        } else {
            dismissAllShopType()
        }
        
        for item in shopType {
            if item.name == "Gold Merchant" {
                self.goldMerchantFlag = true
            }
            
            if item.name == "Official Store" {
                self.officalStoreFlag = true
            }
        }
    }
}

protocol FilterProtocol {
    func filterData(minPrice : Int, maxPrice : Int, wholeSaleFlag : Bool, goldMerchant : Bool, officialStore : Bool, reset : Bool, shopType: [ShopType])
}
