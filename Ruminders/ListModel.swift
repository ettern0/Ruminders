//
//  ListModel.swift
//  Ruminders
//
//  Created by Евгений Сердюков on 22.10.2021.
//

import Foundation
import SwiftUI
import CoreData


//style of picture buttons
struct ToolbarButtonStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon.font(.headline)
            configuration.title.font(.subheadline)
        }.padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -10))
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ListView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State var showMenu: Bool = false
    var rowPosition: CGPoint = CGPoint(x: 0, y: 0)
    let actions = [ DropDownAction(title: "Show preferences", action: { }),
                    DropDownAction(title: "Share", action: { }),
                    DropDownAction(title: "Delete", action: { })]
    
    var body: some View {

        ZStack {
            NavigationView {
                List {
                        ForEach(items) { item in
                            NavigationLink { Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                            } label: { Text(item.timestamp!, formatter: itemFormatter) }
                            .onTapGesture {
                                if showMenu { self.showMenu.toggle() }}
                            .onLongPressGesture {
                                withAnimation {
                                    self.showMenu.toggle() }}
                        }
                        .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem(placement: .bottomBar) {
                        toolbarCustomButtom
                    }

                }
                .navigationTitle(Text("My list"))
            }
            .blur(radius: showMenu ? 1 : 0)
            if showMenu {
                DropDownView(menuActions: actions, showHeader: true, title: "asd", showMenu: $showMenu)
            }
        }
    }

    var toolbarCustomButtom: some View {
        HStack {
            Button(action: { }) { Label("Notification", systemImage: "plus.circle.fill") }
            .labelStyle(ToolbarButtonStyle())
            Spacer()
            Button(action: addItem) { Label("add list", systemImage: "") }
            .labelStyle(ToolbarButtonStyle())
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
