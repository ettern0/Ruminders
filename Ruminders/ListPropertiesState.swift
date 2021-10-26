//
//  ListPropertiesState.swift
//  Ruminders
//
//  Created by Евгений Сердюков on 22.10.2021.
//

import SwiftUI
import CoreData

enum ListPropertiesState: Identifiable {
    var id: String {
        switch self {
        case .list(let list):
            return list.objectID.uriRepresentation().absoluteString
        case .empty:
            return "empty"
        }
    }

    case list(ListSet)
    case empty
}
