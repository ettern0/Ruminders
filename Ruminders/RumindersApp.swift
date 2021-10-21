//
//  RumindersApp.swift
//  Ruminders
//
//  Created by Евгений Сердюков on 21.10.2021.
//

import SwiftUI

@main
struct RumindersApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
