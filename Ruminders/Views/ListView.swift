
import SwiftUI

public struct ListView: View {

    @ObservedObject var listsViewModel: ListsViewModel = ListsViewModel.instance
    @State var selectedList: ListSet?
    @State var showView = false
    @State var showRow: ListPropertiesState?
    @State var activeView: AnyView?
    @State var mode: EditMode = .inactive
    let headerHeight = CGFloat(24)

    public  var body: some View {
        NavigationView {
            VStack {
                //speachButtonView()
                navigation
                List {
                    Section(header: ListHeader()) {
                        ForEach(listsViewModel.lists) { element in
                            ListRowView(list: element, mode: mode, show: $showRow)
                                .onLongPressGesture {
                                    self.selectedList = element
                                }
                                .background(Color(.white))
                                .contextMenu {
                                    ButtonListProperty(showRow: $showRow, list: element)
                                    ButtonListShare(list: element)
                                    ButtonListDelete(list: element)
                                }
                        }
                        .onDelete(perform: deleteLists)
                        .onMove { self.moveList(from: $0, to: $1) }
                    }
                }
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

    func deleteLists(offsets: IndexSet) {
        let array = offsets.map { listsViewModel.lists[$0] }
        array.forEach { element in
            listsViewModel.delete(list: element)
        }
    }

    func moveList(from: IndexSet, to: Int) {
        let array = from.map { listsViewModel.lists[$0] }
        array.forEach { element in
            listsViewModel.save(list: element, position: to)
        }
    }
}


struct ListHeader: View {
    var body: some View {
        HStack {
//            LottieView(name: "pencil")
//                           .frame(width: 60, height: 60, alignment: .leading)
            Text("My lists")
                .font(.largeTitle)

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
            ListsViewModel.instance.delete(list: list)
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


struct speachButtonView: View {
    @ObservedObject var speechRec = SpeechRec()
    var body: some View {
        VStack {
            Text(speechRec.recognizedText)
                .font(.largeTitle)
                .padding()
            Button(action: {
                if self.speechRec.isRunning {
                    self.speechRec.stop()
                } else {
                    self.speechRec.start()
                }
            }) {
                Text(self.speechRec.isRunning ? "Stop" : "Start")
                    .font(.title)
                    .padding()
            }
        }
        .onAppear {
            self.speechRec.start()
        }
    }
}
