//
//  ListView.swift
//  Ruminders
//
//  Created by Евгений Сердюков on 26.10.2021.
//

import SwiftUI

struct ListView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ListSet.timestamp, ascending: true)],
        animation: .default)
    private var lists: FetchedResults<ListSet>
    @State var activeList: Ruminders.ListSet?

    @State var selectedList: ListSet?
    @State var showView = false
    @State var showListPropertiesItem: ListPropertiesState?
    @State var activeView: AnyView?
    private var navigationTitle = "Back"

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: self.activeView.navigationBarTitle(navigationTitle, displayMode: .inline),
                    isActive: $showView
                ) {
                    EmptyView()
                }
                .sheet(item: $showListPropertiesItem, content: { list in
                    switch list {
                    case .list(let list):
                        ListContext(list: list, show: $showListPropertiesItem)
                    case .empty:
                        ListContext(list: nil, show: $showListPropertiesItem)
                    }
                })
                List {
                    ForEach(lists) { list in
                        ListRowView(list: list)
                            .onLongPressGesture {
                                self.activeList = list
                                self.selectedList = list
                            }
                            .background(Color(.white))
                                .contextMenu {
                                    buttonListProperty
                                    buttonListShare
                                    buttonListDelete
                                }
                    }
                    .onDelete(perform: deleteLists)
                }
                .navigationTitle(Text("My lists"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem(placement: .bottomBar) {
                        toolbarCustomButtom
                    }
                }
            }
        }
    }

    var toolbarCustomButtom: some View {
        HStack {
            Button(action: { }) { Label("Notification", systemImage: "plus.circle.fill") }
            .labelStyle(ToolbarButtonStyle())
            Spacer()
            Button(action: addList) { Label("add list", systemImage: "") }
            .labelStyle(ToolbarButtonStyle())
        }
    }

    var buttonListProperty: some View {
        Button(action: {
            if let list = self.selectedList {
                self.showListPropertiesItem = .list(list)
            }
        },
               label: {
            HStack {
                Text("Show list property")
                Spacer()
                Image(systemName: "pencil")
            }
        })
    }

    var buttonListShare: some View {
        Button(action: {},
               label: {
            HStack {
                Text("Share list")
                Spacer()
                Image(systemName: "person.crop.circle.badge.plus")
            }
        })
    }

    var buttonListDelete: some View {
        return Button(role: .destructive) {
            if let list = self.selectedList {
                let index = lists.firstIndex(of: list)
                let indexSet = IndexSet(integer: index!)
                deleteLists(offsets: indexSet)
            }
        } label: {
            HStack {
                Text("Delete list")
                Spacer()
                Image(systemName: "trash")
            }
        }
    }

    private func addList() {
        withAnimation {
            //self.activeList = nil
            self.showListPropertiesItem = .empty
        }
    }

     func deleteLists(offsets: IndexSet) {
        withAnimation {
            offsets.map { lists[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//style of picture buttons
private struct ToolbarButtonStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon.font(.headline)
            configuration.title.font(.subheadline)
        }.padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -10))
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
