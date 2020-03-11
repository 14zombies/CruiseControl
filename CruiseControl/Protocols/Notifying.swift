//
//  Notifying.swift
//  CruiseControl
//
//  Created by Calum Crawford on 11/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Foundation

protocol Notifying: AnyObject {
    func willNotify(capsLockEnabled: Bool)
}
