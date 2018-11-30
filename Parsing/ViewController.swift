//
//  ViewController.swift
//  Parsing
//
//  Created by David Tacite on 20/11/2018.
//  Copyright © 2018 David Tacite. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        doRequest()
    }

    func doRequest() {
        Alamofire.request("http://www.amiiboapi.com/api/amiibo/?name=mario").response { (response) in
            if let data = response.data {
                print(data)
                self.parse(data: data)
            }
        }
    }
    
    func parse(data: Data) {
        do {
        let decoder = JSONDecoder()
        let amiibos = try decoder.decode(AmiiboList.self, from: data)
        for amiibo in amiibos.amiibo {
                print(amiibo)
            let encoder = JSONEncoder()
            let data = try encoder.encode(amiibo.self)
            print(String(data: data, encoding: String.Encoding.utf8))
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

