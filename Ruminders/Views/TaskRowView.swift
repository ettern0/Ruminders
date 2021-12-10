
import SwiftUI

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
                    withAnimation {
                        tvm.setName(task: task, name: name)
                    }
                }
            }
        }
    }

    var conditionButton: some View {
        Button {
            withAnimation {
                done.toggle()
                tvm.setCondition(task: task, condition: done)
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
