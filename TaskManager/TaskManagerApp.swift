//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Maxim Gaida on 03.06.2023.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
