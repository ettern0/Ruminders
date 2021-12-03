import SwiftUI
import simd

struct TasksView: View {

    @ObservedObject var lvm: ListsViewModel = ListsViewModel.instance
    let list: ListSet

    @State var arrayOfTasks: [TaskStruct] = []

    init(list: ListSet) {
        self.list = list
        list.tasksArray.forEach { task in
            arrayOfTasks.append(TaskStruct(task: task))
        }
    }


    var body: some View {
        NavigationView {

            //list
            List {
                Section(header: listHeader) {
                    ForEach(arrayOfTasks) { element in
                        TaskRowView(arrayOfTasks: $arrayOfTasks,done: element.done, task: element)
                    }
                }
                .onTapGesture {
                    arrayOfTasks.append(TaskStruct(position: NSNumber(value: arrayOfTasks.count)))
                }
            }
        }
        //-list
    }

    var listHeader: some View {
        HStack {
            Text(list.name ?? "")
                .font(.largeTitle)
        }
    }
}


struct TaskRowView: View {

    @Binding var arrayOfTasks: [TaskStruct]
    @State var done: Bool
    var task: TaskStruct

    let size: CGFloat = 20

    var body: some View {
        HStack {
        conditionButton
            Text(done ? "done" : "undone")
        }

    }


    var conditionButton: some View {
        Button {
            if let index = arrayOfTasks.firstIndex(of: task) {
                arrayOfTasks[index].toggleCondition()
                done = arrayOfTasks[index].done
            }
        } label: {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: task.done ? "largecircle.fill.circle" : "circle")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
            }
        }


}
}
