//
//  BtcTableViewCell.swift
//  BITCOIN
//
//  Created by Hasan onur Can on 16.02.2022.
//

import UIKit

class BtcTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var favoriteImg: UIImageView!
    @IBOutlet weak var changeLbl: UILabel!
    @IBOutlet weak var btcImg: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeLbl.layer.cornerRadius = changeLbl.frame.size.height / 5

       
        
    }
 
    
    
    
    var delegate: BtcDelegate?
    var selectedBtc: BtcModel!
    
    
    func designCell(btc : BtcModel, delegate: BtcDelegate?){
        
        nameLbl.text = btc.btcSymbol
        priceLbl.text = String(format: "%.3f", btc.btcPrice)
        btcImg.image = UIImage(named: "btc")
        changeLbl.text = String(format: "%.1f", btc.change)
        selectedBtc = btc
        if btc.like == true{
        print("girdim ke")
            favoriteImg.image = UIImage(named: "yildizRenkli")
        }else{
            favoriteImg.image = UIImage(named: "yildizTransparan")
           
        }
            

            if btc.change<0{
                changeLbl.backgroundColor = .red
            }else{
                changeLbl.backgroundColor = .green
            
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(favoriteImgTapped))
    
        favoriteImg.addGestureRecognizer(tap)
        favoriteImg.isUserInteractionEnabled = true
       
        
    }
    
    
    @objc func favoriteImgTapped(){
        delegate?.favoriteImgPressed(btc : selectedBtc)
        if selectedBtc.like == false{
            favoriteImg.image = UIImage(named: "yildizRenkli")
            selectedBtc.like=true
        }else{
            favoriteImg.image = UIImage(named: "yildizTransparan")
            selectedBtc.like=false
        }
                }
    }
   

protocol BtcDelegate{
    func favoriteImgPressed (btc: BtcModel)
    
}

