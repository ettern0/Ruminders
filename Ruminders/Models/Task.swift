import CoreData
import SwiftUI

public struct TaskModel {

    private let moc: NSManagedObjectContext
    private let list: ListSet
    private var refreshModel:Bool = false
    private (set) var tasks: [TaskStruct] = []

    init (list: ListSet) {
        moc = PersistenceController.shared.container.viewContext
        self.list = list
        list.tasksArray.forEach { task in
            tasks.append(TaskStruct(task: task))
        }
    }

    mutating func appendTaskOnPosition(position: Int32 = 0) {
        tasks.append(TaskStruct(position: position))
    }

    mutating func setName(task: TaskStruct, name: String) {
        if let index = tasks.firstIndex(of: task) {
            if name.isEmpty {
                delete(task: tasks[index])
                return
            }
            tasks[index].name = name
            save(task: tasks[index])
        }
    }

    mutating func setCondition(task: TaskStruct, condition: Bool) {
        if let index = tasks.firstIndex(of: task) {
            tasks[index].done = condition
            save(task: tasks[index])
        }
    }

    mutating func save(task: TaskStruct) {
            let item = task.task ?? Tasks(context: moc)
            item.timestamp = Date()
            item.name = task.name
            item.position = NSNumber(value: task.position)
            item.done = task.done
            item.listSet = self.list
            do {
                try moc.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
    }

    mutating func delete(task: TaskStruct) {
        if let task = task.task {
            moc.delete(task)
            refreshModel.toggle()
        }
        if let index = tasks.firstIndex(of: task) {
            tasks.remove(at: index)
        }
    }
}

struct TaskStruct: Identifiable, Equatable {

    var id: Int32
    let task: Tasks?
    var name: String = ""
    var position: Int32 = 0
    var timeStamp: Date = Date()
    var done: Bool = false
    var mutated: Bool = false

    init(task: Tasks? = nil, position: Int32 = 0) {
        self.task = task
        self.name = task?.name ?? ""
        self.timeStamp = task?.timestamp ?? Date()
        self.done = task?.done ?? false
        if let taskPosition = task?.position {
            self.position = Int32(truncating: taskPosition)
        } else {
            self.position = position
        }
        if let taskPosition = task?.position {
            self.id = Int32(truncating: taskPosition)
        } else {
            self.id = Int32(position)
        }
    }

    mutating func toggleCondition() {
        self.done.toggle()
    }
}
