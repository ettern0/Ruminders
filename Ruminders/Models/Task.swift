import CoreData
import SwiftUI

public struct TaskModel {

    private let moc: NSManagedObjectContext
    //private (set) var tasks: [Tasks]?
    private let list: ListSet

    init (list: ListSet) {
        moc = PersistenceController.shared.container.viewContext
        self.list = list
    }

    var tasks: [TaskStruct] {
        var tasks: [TaskStruct] = []
        list.tasksArray.forEach { task in
            tasks.append(TaskStruct(task: task))
        }
        return tasks
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
            self.position = Int32(taskPosition)
        } else {
            self.position = position
        }
        if let taskPosition = task?.position {
            self.id = Int32(taskPosition)
        } else {
            self.id = Int32(position)
        }
    }

    mutating func toggleCondition() {
        self.done.toggle()
    }
}
