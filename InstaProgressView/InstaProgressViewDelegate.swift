//
//  InstaProgressViewDelegate.swift
//  InstaProgressView
//
//  Created by Eduard Sinyakov on 11/19/20.
//

import Foundation

public protocol InstaProgressViewDelegate: class {
    func instaProgressViewChangedIndex(index: Int)
    func instaProgressViewFinished()
}
