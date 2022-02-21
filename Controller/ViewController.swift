//
//  ViewController.swift
//  BITCOIN
//
//  Created by Hasan onur Can on 16.02.2022.
//

import UIKit

class ViewController: UIViewController,UITabBarControllerDelegate{
    
   
    @IBOutlet weak var portfoyTableView: UITableView!
    
    var selectedBtc: BtcModel!
   
    
    var tcell = BtcTableViewCell()
    var btcArray = [BtcModel ]()
    var favoriteBtc = [BtcModel]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performRequest(btcURL: btcURL)
        portfoyTableView.dataSource = self
        portfoyTableView.delegate = self
        portfoyTableView.register(UINib(nibName: "BtcTableViewCell", bundle: nil), forCellReuseIdentifier: "ToCelll")
        
        print(self.btcArray.count)
        // Do any additional setup after loading the view.
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(favoriteBtc)
            try data.write(to:self.dataFilePath!)
        }catch{
            print(error)
        }
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
                        let btc = self.parseJSON(btcData: safedata)
                           
                        
                        
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
                   
                    btcArray.append(btc)
                    a+=1
                
                }
                
                DispatchQueue.main.async {
                    
                   
                    self.portfoyTableView.reloadData()
                    
                }
                
              
               return btcArray
               
            }catch{
                print(error)
                return nil
            }
    }
          

}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return btcArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ToCelll", for: indexPath) as? BtcTableViewCell{
            cell.selectionStyle = .none
            cell.designCell(btc: self.btcArray[indexPath.row], delegate: self)
            cell.delegate = self
            return cell
        }
 
        
    
        return UITableViewCell()
    }
    
    
}
extension ViewController : BtcDelegate{
    func favoriteImgPressed(btc: BtcModel) {
        
        selectedBtc = btc
        if btc.like == false{
            favoriteBtc.append(btc)
            saveItems()
        }else{
            var index = -1
            for a in favoriteBtc{
                if a.btcSymbol==btc.btcSymbol{
                    
                }
                index+=1
            }
            favoriteBtc.remove(at: index)
            saveItems()
        }
                               }
}


