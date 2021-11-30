//
//  ListView.swift
//  Ruminders
//
//  Created by Евгений Сердюков on 26.10.2021.
//

import SwiftUI

public struct ListView: View {

    @ObservedObject var listsViewModel: ListsViewModel = ListsViewModel.instance
    @State var selectedList: ListSet?
    @State var showView = false
    @State var showListPropertiesItem: ListPropertiesState?
    @State var activeView: AnyView?
    private var navigationTitle = "Back"

   public  var body: some View {

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
                    ForEach(listsViewModel.lists) { element in
                        ListRowView(list: element)
                            .onLongPressGesture {
                                self.selectedList = element
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
                .navigationTitle(
                    Text("My lists"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                        LottieButton(name: "gridListAnimation", action: {})
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
                let index = listsViewModel.lists.firstIndex(of: list)
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
            self.showListPropertiesItem = .empty
        }
    }

     func deleteLists(offsets: IndexSet) {
         let array = offsets.map { listsViewModel.lists[$0] }
         array.forEach { element in
             listsViewModel.delete(list: element)
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


