//
//  Constants.swift
//  CruiseControl
//
//  Created by Calum Crawford on 16/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Foundation

class Constants {

    static var appName: String {
        Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Cruise Control"
    }
    
    static var mainBundleID: String = "com.somevideotapes.CruiseControl"
    static var helperBundleID: String = "com.somevideotapes.CruiseControlHelper"
}
