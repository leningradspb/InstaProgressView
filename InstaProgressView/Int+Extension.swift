//
//  Int+Extension.swift
//  InstaProgressView
//
//  Created by Eduard Sinyakov on 11/19/20.
//

import Foundation
extension Int: Sequence {
    public func makeIterator() -> CountableRange<Int>.Iterator {
        return (0..<self).makeIterator()
    }
}
