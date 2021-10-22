//
//  ContentView.swift
//  Ruminders
//
//  Created by Евгений Сердюков on 21.10.2021.
//
//Настройка "Оставлять
// Иерархия -


import SwiftUI
import CoreData


struct ContentView: View {

    var body: some View {
        ListView()
    }
}










struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
