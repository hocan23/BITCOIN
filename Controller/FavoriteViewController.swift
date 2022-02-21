//
//  FavoriteViewController.swift
//  BITCOIN
//
//  Created by Hasan onur Can on 17.02.2022.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BtcDelegate{
    func favoriteImgPressed(btc: BtcModel) {
       loadItems()
        print("çalışıyorum")
    }
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var favoriteBtc: [BtcModel]!
    

    @IBOutlet weak var favoriteTableView: UITableView!
    override func viewDidLoad() {
        loadItems()
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
       favoriteTableView.register(UINib(nibName: "BtcTableViewCell", bundle: nil), forCellReuseIdentifier: "ToCelll")

    }
    override func viewWillAppear(_ animated: Bool) {
        loadItems()
        favoriteTableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteBtc.count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ToCelll", for: indexPath) as? BtcTableViewCell{
       
            cell.designCell(btc: self.favoriteBtc[indexPath.row], delegate: self)
            cell.delegate = self
            return cell
        }
 
        
    
        return UITableViewCell()
    }
            
        
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                favoriteBtc = try decoder.decode([BtcModel].self, from: data)
            }catch{
                print(error)
            }
        }
    }
    

}
