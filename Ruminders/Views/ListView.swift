
import SwiftUI

public struct ListView: View {

    @ObservedObject var lvm: ListsViewModel = ListsViewModel.instance
    var cvm: CategoryViewModel = CategoryViewModel.instance
    @State var selectedList: ListSet?
    @State var showView = false
    @State var showRow: ListPropertiesState?
    @State var activeView: AnyView?
    @State var mode: EditMode = .inactive
    @State var searchText = ""
    @State var showCancelButton: Bool = false
    let headerHeight = CGFloat(24)

    public var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(.secondarySystemBackground))
                    .ignoresSafeArea()
                VStack {
                    SearchView(searchText: $searchText, showCancelButton: $showCancelButton)
                    categoriesView
                    mainElementsView
                }
            }
        }
    }

    var categoriesView: some View {
        List {
            ForEach(cvm.categoriesWithTasks, id: \.category) { element in
                HStack {
                    Text(element.category.rawValue)
                    Text(String(element.tasks.count))
                }
            }
        }
    }

    var mainElementsView: some View {
        VStack {
            navigation
            List {
                Section(header: listHeader) {
                    ForEach(lvm.lists.filter { $0.name!.hasPrefix(searchText) || searchText == "" }) { element in
                        ListRowView(list: element, mode: mode, show: $showRow)
                            .background(Color(.white))
                            .contextMenu {
                                ButtonListProperty(showRow: $showRow, list: element)
                                ButtonListShare(list: element)
                                ButtonListDelete(list: element)
                            }
                            .onTapGesture {
                                self.activeView = AnyView(TasksView(list: element))
                                self.showView.toggle()
                            }
                    }
                    .onDelete(perform: deleteLists)
                    .onMove { self.moveList(from: $0, to: $1) }
                }
            }
            .resignKeyboardOnDragGesture(empty: mode == .inactive)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .bottomBar) {
                    toolbarCustomButtom
                }
            }
            .environment(\.editMode, $mode)
        }
    }

    var navigation: some View {
        NavigationLink(
            destination: self.activeView.navigationBarTitle("Back", displayMode: .inline),
            isActive: $showView
        ) {
            EmptyView()
        }
        .sheet(item: $showRow, content: { list in
            switch list {
            case .list(let list):
                ListContext(list: list, show: $showRow)
            case .empty:
                ListContext(list: nil, show: $showRow)
            }
        })
    }

    var toolbarCustomButtom: some View {
        HStack {
            Button(action: { }) { Label("Notification", systemImage: "plus.circle.fill") }
            .labelStyle(ToolbarButtonStyle())
            Spacer()
            Button(action: {
                showRow = .empty
            }) { Label("add list", systemImage: "") }
            .labelStyle(ToolbarButtonStyle())
        }
    }

    var listHeader: some View {
        HStack {
            Text("My lists")
                .font(Font.largeTitle.weight(.bold))
        }
    }

    func deleteLists(offsets: IndexSet) {
        let array = offsets.map { lvm.lists[$0] }
        array.forEach { element in
            lvm.deleteList(list: element)
        }
    }

    func moveList(from: IndexSet, to: Int) {
        let array = from.map { lvm.lists[$0] }
        array.forEach { element in
            lvm.saveList(list: element, position: to)
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

struct ButtonListProperty: View {
    @Binding var showRow: ListPropertiesState?
    var list:ListSet
    var body: some View {
        Button {
            showRow = .list(list)
        } label: {
            HStack {
                Text("Show list property")
                Spacer()
                Image(systemName: "pencil")
            }
        }
    }
}

struct ButtonListDelete: View {
    var list:ListSet
    var body: some View {
        Button(role: .destructive) {
            ListsViewModel.instance.deleteList(list: list)
        } label: {
            HStack {
                Text("Delete list")
                Spacer()
                Image(systemName: "trash")
            }
        }
    }
}

struct ButtonListShare: View {
    var list:ListSet
    var body: some View {
        Button {

        } label: {
            HStack {
                Text("Share list")
                Spacer()
                Image(systemName: "person.crop.circle.badge.plus")
            }
        }
    }
}
