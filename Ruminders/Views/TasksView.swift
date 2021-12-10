import SwiftUI
import simd

struct TasksView: View {

    @ObservedObject var tvm: TasksViewModel
    let list: ListSet

    init(list: ListSet) {
        self.list = list
        tvm = TasksViewModel(list: list)
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: listHeader) {
                        ForEach(tvm.tasks) { element in
                            TaskRowView(model: tvm, task: element)
                        }
                    }
                    .ignoresSafeArea()
                }
                Button(action: {
                    tvm.appendTaskOnPosition(position: Int32(tvm.tasks.count))
                }) { Label("add task", systemImage: "") }
            }
        }
    }

    var listHeader: some View {
        HStack {
            Text(list.name ?? "")
                .font(Font.largeTitle.weight(.bold))
                .foregroundColor(getColor(data: list.color))
        }
    }
}

