//
//  NestCoordinator.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-09.
//

import SwiftUI

enum NestTab {
    case search
    case publishedListings
    case profile
}

@Observable
class NestCoordinator {
    var currentTab: NestTab = .search
}
