import CoreData
import SwiftUI

public struct TaskModel {

    private let moc: NSManagedObjectContext
    private (set) var tasks: [Tasks]?
    private let list: ListSet

    init (list: ListSet) {
        moc = PersistenceController.shared.container.viewContext
        self.list = list
        tasks = list.tasksArray
    }

    mutating func save(task: TaskStruct) {

        let item = task.task ?? Tasks(context: moc)
        item.timestamp = Date()
        item.name = task.name
        item.position = NSNumber(nonretainedObject: task.position)
        item.done = task.done
        do {
            try moc.save()
            tasks = list.tasksArray
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct TaskStruct: Identifiable, Equatable {

    var id: NSNumber
    let task: Tasks? = nil
    var name: String = ""
    var position: NSNumber = 0
    var timeStamp: Date = Date()
    var done: Bool = false
    var mutated: Bool = false

    init(task: Tasks? = nil, position: NSNumber = 0) {
        self.name = task?.name ?? ""
        self.timeStamp = task?.timestamp ?? Date()
        self.done = task?.done ?? false
        if let taskPosition = task?.position {
            self.position = taskPosition
        } else {
            self.position = position
        }
        if let taskPosition = task?.position {
            self.id = taskPosition
        } else {
            self.id = position
        }
    }

    mutating func toggleCondition() {
        self.done.toggle()
    }
}
