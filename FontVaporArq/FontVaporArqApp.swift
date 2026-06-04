//
//  FontVaporArqApp.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI

@main
struct FontVaporArqApp: App {
    @StateObject private var contaStore = ContaStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contaStore)
        }
        .defaultSize(width: 960, height: 640)
        .windowResizability(.contentMinSize)
    }
}
