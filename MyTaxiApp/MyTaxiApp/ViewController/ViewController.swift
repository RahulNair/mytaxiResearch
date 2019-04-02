//
//  ViewController.swift
//  MyTaxiApp
//
//  Created by Rahul Nair on 02/04/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var appDelegate : AppDelegate?
    let cellIdentifier = "vechilelistCellID"
    
    var vechileDataList : [MTVechileDataModel] = []
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var w_self = self

        appDelegate =  (UIApplication.shared.delegate as! AppDelegate)
        
        
        
        tableView.register(UINib(nibName: "VechileListCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        loadData { (err) in
            if err != nil{
                print("error occurred")
            }else{
                DispatchQueue.main.async {
                    w_self!.tableView.reloadData()
                }
                
            }
            
        }
    }

    
    func loadData(completion:  @escaping (MTError?) -> Void)  {
        weak var w_self = self
        let url = "https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891"
        appDelegate?.networkManagerSharedInstance?.performNetworkOperation(method: MTHTTPMethod.get, urlString: url, params: nil, header: nil, completion: { (result) in
            switch result {
            case .success(let value):
                print(value)
                do {
                    let decoder = JSONDecoder()
                    let root = try decoder.decode(Root.self, from: value)
                    w_self?.vechileDataList = root.poiList
                    completion(nil)
                } catch let err {
                    print("Err", err)
                    completion(err as! MTError)
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
    }

}

extension ViewController : UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vechileDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : VechileListCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! VechileListCell
        cell.setValueForCell(model: vechileDataList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
