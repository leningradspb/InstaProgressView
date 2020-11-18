//
//  InstaProgressViewDelegate.swift
//  InstaProgressView
//
//  Created by Eduard Sinyakov on 11/19/20.
//

import Foundation

protocol InstaProgressViewDelegate: class {
    func instaProgressViewChangedIndex(index: Int)
    func instaProgressViewFinished()
}
