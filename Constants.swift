//
//  Constants.swift
//  CruiseControl
//
//  Created by Calum Crawford on 16/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Foundation

class Constants{
    static var bundleID: String {
           if let bundleID = Bundle.main.bundleIdentifier {
               return bundleID
           }
           fatalError()
    }
    
    static var appName: String{
        Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    }
}
