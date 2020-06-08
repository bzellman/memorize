//
//  Array+Only.swift
//  Memorize
//
//  Created by Bradley Zellman on 6/8/20.
//  Copyright © 2020 Bradley Zellman. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
