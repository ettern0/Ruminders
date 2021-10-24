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




struct TestCustomCellHighlight: View {
    @State var selection: Int = -1
    @State var highlight = false
    @State var showDetails = false

    init() {
        UITableViewCell.appearance().selectionStyle = .none
    }

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Text("Details \(self.selection)"), isActive: $showDetails) {
                    EmptyView()
                }
                List(0..<20, id: \.self) { i in
                    HStack {
                        Text("Item \(i)")
                        Spacer()
                    }
                    .padding(.vertical, 6)
                    .background(Color.white) // to be tappable row-wide
                    .overlay(self.highlightView(for: i))
                    .onTapGesture {
                        self.selection = i
                        self.highlight = true

                        // delay link activation to see selection effect
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.highlight = false
                            self.showDetails = true
                        }
                    }
                }
            }
        }
    }

    private func highlightView(for index: Int) -> AnyView {
        if self.highlight && self.selection == index {
            return AnyView(Rectangle().inset(by: -5).fill(Color.red.opacity(0.5)))
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct TestCustomCellHighlight_Previews: PreviewProvider {
    static var previews: some View {
        TestCustomCellHighlight()
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
