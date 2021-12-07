import SwiftUI
import simd

struct TasksView: View {

    @ObservedObject var tvm: TasksViewModel
    let list: ListSet
    @State var arrayOfTasks: [TaskStruct] = []

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

struct TaskRowView: View {

    let tvm: TasksViewModel
    @State var done: Bool = false
    @State var name: String = ""
    var task: TaskStruct

    init(model: TasksViewModel, task: TaskStruct) {
        self.tvm = model
        self.task = task
        if let index = tvm.tasks.firstIndex(of: task) {
            _done = .init(initialValue: tvm.tasks[index].done)
            _name = .init(initialValue: tvm.tasks[index].name)
        }
    }

    var body: some View {
        HStack {
            conditionButton
            TextField(name, text: $name) { isEditing in
                if !isEditing {
                    if let index = tvm.tasks.firstIndex(of: task) {
                        tvm.tasks[index].name = name
                        tvm.saveTask(task:  tvm.tasks[index])
                    }
                }
            }
        }
        .onAppear {

        }
    }

    var conditionButton: some View {
        Button {
            if let index = tvm.tasks.firstIndex(of: task) {
                done.toggle()
                tvm.tasks[index].toggleCondition()
                tvm.saveTask(task:  tvm.tasks[index])
            }
        } label: {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: done ? "largecircle.fill.circle" : "circle")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }
        }
    }
}
