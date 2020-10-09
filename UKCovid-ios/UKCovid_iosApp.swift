//
//  UKCovid_iosApp.swift
//  UKCovid-ios
//
//  Created by Suica on 10/10/2020.
//

import SwiftUI

@main
struct UKCovid_iosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
