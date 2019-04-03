//
//  NetworkManagerTests.swift
//  MyTaxiAppTests
//
//  Created by Rahul Nair on 02/04/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import XCTest
import MapKit
@testable import MyTaxiApp

class NetworkManagerTests: XCTestCase {
    
    var coordinate_a: CLLocationCoordinate2D?
    var coordinate_b: CLLocationCoordinate2D?
    
    
    var url = "https://poi-api.mytaxi.com/PoiService/poi/v1"
    
    func waitForRequestDefaultTimeout() {
        self.waitForExpectations(timeout: 200, handler: { (error) -> Void in
            if error != nil {
                XCTFail("Could not perform operation (Timed out) ~ ERR: " + (error?.localizedDescription)!)
            }
        })
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coordinate_a = CLLocationCoordinate2D(latitude:53.694865 , longitude: 9.757589)
        coordinate_b = CLLocationCoordinate2D(latitude:53.394655 , longitude: 10.099891)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        url = "https://poi-api.mytaxi.com/PoiService/poi/v1"
    }

    func testDataWithBadURL() {
        let instance = NetworkManager()
        let expectation = self.expectation(description: "MTTEST")

        url = ""
        
        let params : MTParams = ["p2Lat":coordinate_b?.latitude ?? 0.0,
                                 "p2Lon": coordinate_b?.longitude ?? 0.0,
                                 "p1Lat": coordinate_a?.latitude ?? 0.0,
                                 "p1Lon": coordinate_a?.longitude ?? 0.0]
        
        
                instance.performNetworkOperation(method: .get, urlString: url, params: params, header: nil) { (result) in
                    
                    XCTAssertNotNil(result,"result is nil")
                    
                    switch result {
                    case .success(let value):
                        XCTAssertNotNil(value,"value is nil")
                    case .failure(let error):
                        XCTAssertNotNil(error,"error is nil")

                    }
                    
                    expectation.fulfill()
            }
            
        self.waitForRequestDefaultTimeout()
    }
    
    func testDataWithBadParam() {
        let instance = NetworkManager()
        let expectation = self.expectation(description: "MTTEST")
        
        let params : MTParams = ["p2aLat":coordinate_b?.latitude ?? 0.0,
                                 "pa2Lon": coordinate_b?.longitude ?? 0.0,
                                 "pa1Lat": coordinate_a?.latitude ?? 0.0,
                                 "p1xLon": coordinate_a?.longitude ?? 0.0]
        
        
        instance.performNetworkOperation(method: .get, urlString: url, params: params, header: nil) { (result) in
            
            XCTAssertNotNil(result,"result is nil")
            
            switch result {
            case .success(let value):
                XCTAssertNotNil(value,"value is nil")
            case .failure(let error):
                XCTAssertNotNil(error,"error is nil")
                
            }
            
            expectation.fulfill()
        }
        
        self.waitForRequestDefaultTimeout()
    }
    
    func testDataWithBadParamURL() {
        let instance = NetworkManager()
        let expectation = self.expectation(description: "MTTEST")
        
        url = ""

        let params : MTParams = ["p2aLat":coordinate_b?.latitude ?? 0.0,
                                 "pa2Lon": coordinate_b?.longitude ?? 0.0,
                                 "pa1Lat": coordinate_a?.latitude ?? 0.0,
                                 "p1xLon": coordinate_a?.longitude ?? 0.0]
        
        
        instance.performNetworkOperation(method: .get, urlString: url, params: params, header: nil) { (result) in
            XCTAssertNotNil(result,"result is nil")

            switch result {
                
            case .success(let value):
                XCTAssertNotNil(value,"value is nil")
            case .failure(let error):
                XCTAssertNotNil(error,"error is nil")
                
            }
            
            expectation.fulfill()
        }
        
        self.waitForRequestDefaultTimeout()
    }
    

    func testDataWithRightUrlParam() {
        let instance = NetworkManager()
        let expectation = self.expectation(description: "MTTEST")
        
        
        let params : MTParams = ["p2Lat":coordinate_b?.latitude ?? 0.0,
                                 "p2Lon": coordinate_b?.longitude ?? 0.0,
                                 "p1Lat": coordinate_a?.latitude ?? 0.0,
                                 "p1Lon": coordinate_a?.longitude ?? 0.0]
        
        
        
        instance.performNetworkOperation(method: .get, urlString: url, params: params, header: nil) { (result) in

            XCTAssertNotNil(result,"result is nil")

            switch result {
            case .success(let value):
                XCTAssertNotNil(value,"value is nil")
                do {
                    let decoder = JSONDecoder()
                    let root = try decoder.decode(Root.self, from: value)
                    XCTAssertNotNil(root.poiList, "root is nil")
                    XCTAssert(root.poiList.count > 0, "no element in list")
                    let vechObj = root.poiList.first
                    XCTAssertNotNil(vechObj?.id, "id elmemnt is nil")
                    XCTAssertNotNil(vechObj?.heading, "heading elmemnt is nil")
                    XCTAssertNotNil(vechObj?.vh_type, "vh_type elmemnt is nil")
                    XCTAssertNotNil(vechObj?.coordinate, "coordinate elmemnt is nil")
                    
                    
                    XCTAssertNotNil(root.poiList, "root is nil")
                    
                    expectation.fulfill()
                    
                } catch let err {
                    print("Err", err)
                    XCTAssert(err == nil,err.localizedDescription)
                    expectation.fulfill()
                    
                }
                
            case .failure(let error):
                XCTAssertNotNil(error,"error is nil")
                
            }
            expectation.fulfill()
        }
        
        self.waitForRequestDefaultTimeout()
    }

}
