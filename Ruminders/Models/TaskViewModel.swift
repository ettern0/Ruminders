
import SwiftUI

public class TasksViewModel: ObservableObject {

    @Published private (set) var model: TaskModel
    private let list: ListSet
    @Published var tasks: [TaskStruct] = []

    init(list: ListSet) {
        model = TaskModel(list: list)
        self.list = list
        list.tasksArray.forEach { task in
            tasks.append(TaskStruct(task: task))
        }

    }

    func appendTaskOnPosition(position: NSNumber = 0) {
        tasks.append(TaskStruct(position: position))
    }
//
//    func saveTask() {
//        model.save()
//    }
}
