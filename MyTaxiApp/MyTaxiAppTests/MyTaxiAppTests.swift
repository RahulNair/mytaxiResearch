//
//  MyTaxiAppTests.swift
//  MyTaxiAppTests
//
//  Created by Rahul Nair on 02/04/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import XCTest
import MapKit

class MyTaxiAppTests: XCTestCase {
    
    var coordinate_a: CLLocationCoordinate2D?
    var coordinate_b: CLLocationCoordinate2D?
    
    
    var url = "https://poi-api.mytaxi.com/PoiService/poi/v1/"
    
    func waitForRequestDefaultTimeout() {
        self.waitForExpectations(timeout: 200, handler: { (error) -> Void in
            if error != nil {
                XCTFail("Could not perform operation (Timed out) ~ ERR: " + (error?.localizedDescription)!)
            }
        })
    }
    
    

    override func setUp() {
        coordinate_a = CLLocationCoordinate2D(latitude:53.694865 , longitude: 9.757589)
        coordinate_b = CLLocationCoordinate2D(latitude:53.394655 , longitude: 10.099891)
        
    }

    override func tearDown() {
       // url = "https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=53.56034183271703&p1Lon=9.757589&0p1Lat=53.694865&p2Lon=10.099891"

    }

    func testValidData() {
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
//                    XCTAssertNotNil(root.poiList, "root is nil")
//                    XCTAssert(root.poiList.count > 0, "no element in list")
//                    let vechObj = root.poiList.first
//                    XCTAssertNotNil(vechObj?.id, "id elmemnt is nil")
//                    XCTAssertNotNil(vechObj?.heading, "heading elmemnt is nil")
//                    XCTAssertNotNil(vechObj?.vh_type, "vh_type elmemnt is nil")
//                    XCTAssertNotNil(vechObj?.coordinate, "coordinate elmemnt is nil")
//
//
//                    XCTAssertNotNil(root.poiList, "root is nil")
                  
                    expectation.fulfill()

                } catch let err {
                    print("Err", err)
                    XCTAssert(err == nil,err.localizedDescription)
                    expectation.fulfill()

                }
            
            case .failure(let error):
                XCTAssertNotNil(error,"error is nil")
                expectation.fulfill()

            }
            
        }
        
        self.waitForRequestDefaultTimeout()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
