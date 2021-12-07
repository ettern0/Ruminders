
import SwiftUI

public class TasksViewModel: ObservableObject {

    @Published private (set) var model: TaskModel
    private let list: ListSet
    @Published var tasks: [TaskStruct] = []

    init(list: ListSet) {
        model = TaskModel(list: list)
        self.list = list
        tasks = model.tasks
    }

    func appendTaskOnPosition(position: Int32 = 0) {
        tasks.append(TaskStruct(position: position))
    }

    func saveTask(task: TaskStruct) {
        model.save(task: task)
    }
//
//    func saveTask() {
//        model.save()
//    }
}
