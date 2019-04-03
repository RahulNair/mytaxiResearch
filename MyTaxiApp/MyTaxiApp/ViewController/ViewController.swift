//
//  ViewController.swift
//  MyTaxiApp
//
//  Created by Rahul Nair on 02/04/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var appDelegate : AppDelegate?
    let cellIdentifier = "vechilelistCellID"
    private let refreshControl = UIRefreshControl()

    
    var vechileDataList : [MTVechileDataModel] = []
   
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.segmentControl.selectedSegmentIndex = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate =  (UIApplication.shared.delegate as! AppDelegate)
        
        loadDesign()
        loadData()
        
       
    }
    
    func loadDesign()  {
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching taxi data !!!", attributes: nil)

        self.loadingActivity.hidesWhenStopped = true
        tableView.register(UINib(nibName: "VechileListCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        showLoading(startAnimating: true)

    }

    
    func loadData()  {
        weak var w_self = self

        fetchData { (err) in
            w_self!.showLoading(startAnimating: false)
            if err != nil{
                print("error occurred")
                self.showAlert(title: "ERROR", message: AppConstants.ErrorMessage.generalError)
            }else{
                DispatchQueue.main.async {
                    w_self!.tableView.reloadData()
                }
                
            }
            
        }
    }
    
    func fetchData(completion:  @escaping (MTError?) -> Void)  {
        weak var w_self = self
        let url = AppConstants.hostURL //"https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891"
       
        let params : MTParams = ["p2Lat":"53.394655",
                                 "p2Lon":"10.099891",
                                 "p1Lat":"53.694865",
                                 "p1Lon":"9.757589"]
        
        appDelegate?.networkManagerSharedInstance?.performNetworkOperation(method: MTHTTPMethod.get, urlString: url, params: params, header: nil, completion: { (result) in
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
                    if let mtError = err as? MTError {
                        
                        completion(mtError)
                    }else{
                        let  newerr = MTError(code: 90, errorType: MTErrorType.parsingError, description: err.localizedDescription)
                        completion(newerr)

                    }
                }
                
            case .failure(let error):
                print(error)
                completion(error)

            }
            
        })
    }
    
    
    @objc private func refreshData(_ sender: Any) {
      
        loadData()
    }
    
    func showLoading(startAnimating : Bool)  {
        
        DispatchQueue.main.async {
            if(startAnimating){
                //            if(self.loadingActivity.isHidden){
                //                self.loadingActivity.isHidden = false
                //            }
                
                self.loadingActivity.startAnimating()
            }else{
                self.loadingActivity.stopAnimating()
                self.refreshControl.endRefreshing()

            }
        }
        
        
    }
    
    
    @IBAction func clickedSegment(_ sender: UISegmentedControl) {
        
        if segmentControl.selectedSegmentIndex == 0 {
            
        }else{
            performSegue(withIdentifier: "showMapViewID", sender: nil)
        }
        
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
extension UIViewController{

    func showAlert(title : String , message : String )  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in}
        
        let alertAction = UIAlertAction(title: "Okay", style: .default) { (_) in}
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}
