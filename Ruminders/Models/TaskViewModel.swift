
import SwiftUI

public class TasksViewModel: ObservableObject {

    @Published private (set) var model: TaskModel
    private let list: ListSet

    init(list: ListSet) {
        model = TaskModel(list: list)
        self.list = list
    }

    var tasks:[TaskStruct] {
        model.tasks
    }

    func appendTaskOnPosition(position: Int32 = 0) {
        model.appendTaskOnPosition(position: position)
    }

    func setName(task: TaskStruct, name: String) {
        model.setName(task: task, name: name)
    }

    func setCondition(task: TaskStruct, condition: Bool) {
        model.setCondition(task: task, condition: condition)
    }

    func saveTask(task: TaskStruct) {
        model.save(task: task)
    }

    func deleteTask(task: TaskStruct) {
        model.delete(task: task)
    }
}
