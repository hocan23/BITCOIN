//
//  WalletViewController.swift
//  BITCOIN
//
//  Created by Hasan onur Can on 17.02.2022.
//

import UIKit

class WalletViewController: UIViewController {
    
    @IBOutlet weak var walletTotal: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    var btcArrayy = [BtcModel]()
    var btcList = ["BTC", "ETH","USDT","XRP","ADA","SOL","AVAX","LUNA","DOGE"]
    var wallet = [WalletModel]()
    var selectedCurrency="BTC"
    
    var amount = 0
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    @IBOutlet weak var walletTableView: UITableView!
    
    @IBOutlet weak var btcPicker: UIPickerView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var amountTextField: UITextField!
    override func viewDidLoad() {
      
        totall()
       
        
        loadItems()
        print(btcArrayy.count)
        
        super.viewDidLoad()
        addButton.layer.cornerRadius = 10
        walletTableView.register(UINib(nibName: "WalletTableViewCell", bundle: nil), forCellReuseIdentifier: "ToWalletCelll")
        performRequest(btcURL: btcURL)
        walletTableView.delegate = self
        walletTableView.dataSource = self
        btcPicker.dataSource = self
        btcPicker.delegate = self
        
    }
    
    func totall(){
        var b = 0
        var tprice = 0.0
        var ttotal = 0.0
        print("girdim")
        while b < wallet.count{
            var c = 0
            
            while c < btcArrayy.count{
                if btcArrayy[c].btcSymbol == wallet[b].name{
                    tprice = btcArrayy[c].btcPrice
                    ttotal+=(Double(tprice)*Double(wallet[b].amount))
                    print(ttotal)
                }
                c+=1
            }
            b+=1
        }
        walletTotal.text=String(ttotal)
    }
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                wallet = try decoder.decode([WalletModel].self, from: data)
            }catch{
                print(error)
            }
        }
    }
    
    
    
    
    func saveItems() {
        print(dataFilePath!)
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(wallet)
            try data.write(to:self.dataFilePath!)
        }catch{
            print(error)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let amount = amountTextField.text.flatMap(Double.init)
        let walletBtc = WalletModel(name: selectedCurrency, amount: Int(amount!))
        wallet.append(walletBtc)
        saveItems()
        walletTableView.reloadData()
        totall()
        
    }
    
    let btcURL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY=95a2c183-765e-4b0b-84be-4ac10bedc337"
    
    
    
    
    func performRequest( btcURL: String ){
        if let url = URL(string: btcURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let safedata = data{
                    if let btc = self.parseJSON(btcData: safedata){
                        
                    }
                    
                }
            }
            
            task.resume()
        }
        
    }
    func parseJSON(btcData: Data)->[BtcModel]?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(BtcData.self, from: btcData)
            var a = 0
            
            while a<20{
                let symbolBtc = decodedData.data[a].symbol
                let priceBtc = Double(decodedData.data[a].quote.usd.price)
                let change = Double(decodedData.data[a].quote.usd.percent_change_24h ?? 0)
                let btc = BtcModel(btcPrice: priceBtc, btcSymbol: symbolBtc, change: change, like: false)
                
                btcArrayy.append(btc)
                a+=1
                
            }
            
            DispatchQueue.main.async {
                
                
                self.walletTableView.reloadData()
                
            }
            
            
            return btcArrayy
            
        }catch{
            print(error)
            return nil
        }
    }
    
    
}
extension WalletViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wallet.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ToWalletCelll", for: indexPath) as? WalletTableViewCell{
            
            DispatchQueue.main.async { [self] in
                cell.name.text = self.wallet[indexPath.row].name
                cell.price.text = String(self.wallet[indexPath.row].amount)
                cell.img.image = UIImage(named: "btc")
                
                
                var price = 0.0
                for a in btcArrayy{
                    if a.btcSymbol == self.wallet[indexPath.row].name{
                        price = a.btcPrice
                    }
                }
                var pprice = price*Double(wallet[indexPath.row].amount)
                
                
                cell.value.text = String(format: "%.2f", pprice)
                
                
                
                
            }
            
            return cell
            
        }
        
        
        
        return UITableViewCell()
    }
    
    
}
extension WalletViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return btcList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return btcList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = btcList[row]
        
        
        
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: btcList[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.cyan])
    }
    
}

extension WalletViewController{
    
    func calculate(){
        
    }
}




