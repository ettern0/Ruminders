
import SwiftUI

public class TasksViewModel: ObservableObject {

    @Published private (set) var model: TaskModel
    let lvm: ListsViewModel = ListsViewModel.instance
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
        lvm.refreshModelState()
    }

    func setCondition(task: TaskStruct, condition: Bool) {
        model.setCondition(task: task, condition: condition)
        lvm.refreshModelState()
    }

    func saveTask(task: TaskStruct) {
        model.save(task: task)
        lvm.refreshModelState()
    }

    func deleteTask(task: TaskStruct) {
        if let index = tasks.firstIndex(of: task) {
            model.delete(task: tasks[index])
            lvm.refreshModelState()
        }
    }
}
