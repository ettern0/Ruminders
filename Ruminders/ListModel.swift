//
//  ListModel.swift
//  Ruminders
//
//  Created by Евгений Сердюков on 22.10.2021.
//

import Foundation
import SwiftUI
import CoreData


struct ListContext: View {

    @Environment(\.managedObjectContext) private var viewContext
    let list: ListSet?
    @State var color: Color
    @State var picture: String
    @State var name: String

    let sizeOfRROfDescription = CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height/5)
    var sizeOfPictureDescription: CGSize { CGSize(width: sizeOfRROfDescription.width*0.2, height: sizeOfRROfDescription.height*0.2) }
    @State var nameIsEditing: Bool = false

    init(list: ListSet?) {

        self.list = list

        if let color = list?.color {
            self.color = getColor(data: color)
        } else {
            self.color = Color.random
        }

        if let picture = list?.picture {
            self.picture = picture
        } else {
            self.picture = "list.bullet"
        }

        if let name = list?.name {
            self.name = name
        } else {
            self.name = ""
        }

    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    descriptionView.padding(.bottom, -20)
                    colorChoiseView.padding(.bottom, -20)
                    signChoiseView
                    //Spacer()
                }
                .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2.5)
            }
        }
    }

    var colorAndSignOfListView: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
                .frame(width: sizeOfPictureDescription.width * 2, height: sizeOfPictureDescription.height * 2)
                .shadow(radius: 5)
            Image(systemName: picture)
                .resizable()
                .scaledToFit()
                .frame(width: sizeOfPictureDescription.width, height: sizeOfPictureDescription.height)
                .foregroundColor(.white)
        }
        .padding(.bottom)
    }

    var textDescriptionView: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: sizeOfRROfDescription.width*0.9, height: sizeOfRROfDescription.height/4)
            .foregroundColor(Color(.systemGroupedBackground))
            .overlay(alignment: .center) {
                HStack {
                    TextField("Name", text: $name) { isEditing in
                            self.nameIsEditing = isEditing
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(color)
                    Spacer()
                    if self.nameIsEditing && self.name != "" {
                        Button {
                            self.name = ""
                        } label: {
                        Image(systemName: "xmark.circle.fill")
                            .padding(.trailing)
                            .foregroundColor(Color(.init(gray: 0, alpha: 0.2)))
                        }
                    }

                }
            }
    }

    var descriptionView: some View {
        VStack {
            Text("Properties")
                .font(Font.headline.weight(.bold))
            RoundedRectangle(cornerRadius: 10)
                .frame(width: sizeOfRROfDescription.width, height: sizeOfRROfDescription.height)
                .foregroundColor(.white)
                .padding(.all)
                .overlay {
                    VStack{
                        colorAndSignOfListView
                        textDescriptionView
                    }
                }
        }
    }

    var colorChoiseView: some View {

        let data = (1...10).map { "Item \($0)" }

         let columns = [
            GridItem(.adaptive(minimum: 40))
         ]

        return RoundedRectangle(cornerRadius: 10)
            .frame(height: UIScreen.main.bounds.height/8)
            .foregroundColor(.white)
            .padding(.all)
            .overlay {
                ScrollView {
                           LazyVGrid(columns: columns, spacing: 15) {
                               ForEach(data, id: \.self) { item in
                                   Circle()
                                       .foregroundColor(Color.random)
                                       .frame(width: 30, height: 30)

                               }
                           }
                           .padding(.horizontal)
                       }
                .padding(.horizontal, 5)
                       .frame(maxHeight: UIScreen.main.bounds.height/10)
                    }

            }

    var signChoiseView: some View {

        let data = (1...100).map { "Item \($0)" }

        let columns = [
            GridItem(.adaptive(minimum: 40))
        ]

        return RoundedRectangle(cornerRadius: 10)
            .frame(height: UIScreen.main.bounds.height/2)
            .foregroundColor(.white)
            .padding(.all)
            .overlay {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(data, id: \.self) { item in
                            Circle()
                                .foregroundColor(Color.random)
                                .frame(width: 30, height: 30)

                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal, 5)
                .frame(maxHeight: UIScreen.main.bounds.height/2 * 0.9)
            }

    }

    private func addList() {
        withAnimation {
            let newItem = ListSet(context: viewContext)
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
}

struct ListView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ListSet.timestamp, ascending: true)],
        animation: .default)
    private var lists: FetchedResults<ListSet>
    @State var activeList: Ruminders.ListSet?
    @State var showView = false
    @State var activeView: AnyView?

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: self.activeView, isActive: $showView) {
                    EmptyView()
                }
                List {
                    ForEach(lists) { list in
                        HStack {
                            Text(list.timestamp!, formatter: itemFormatter)
                            Spacer()
                            HStack {
                            Text("0")
                                Image(systemName: "chevron.right")}
                            .foregroundColor(.gray)
                        }
                        .background(Color(.white))
                            .contextMenu {
                                buttonListProperty
                                buttonListShare
                                buttonListDelete
                            }
                            .onLongPressGesture {
                                activeList = list
                            }
                    }

                    .onDelete(perform: deleteLists)
                }
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
            if let list = activeList {
                self.activeView = AnyView(ListContext(list: list))
                self.showView = true
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
            if let list = activeList {
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
                self.activeView = AnyView(ListContext(list: nil))
                self.showView = true
        }
    }

     func deleteLists(offsets: IndexSet) {
        withAnimation {
            offsets.map { lists[$0] }.forEach(viewContext.delete)
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
