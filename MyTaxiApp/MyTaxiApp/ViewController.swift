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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate =  (UIApplication.shared.delegate as! AppDelegate)
        
        
        
    }

    func loadData(completion:  (Result<Data, MTError>) -> Void)  {
        let url = "https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891"
        appDelegate?.networkManagerSharedInstance?.performNetworkOperation(method: MTHTTPMethod.get, urlString: url, params: nil, header: nil, completion: { (result) in
            switch result {
            case .success(let value):
                print(value)
                do {
                    let decoder = JSONDecoder()
                    let rootList = try decoder.decode(Root.self, from: value)
                    
                } catch let err {
                    print("Err", err)
                }
            case .failure(let error):
                print(error)
            }
            
        })
    }

}

extension ViewController : UITableViewDataSource, UITableViewDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
}
