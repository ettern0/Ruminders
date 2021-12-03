import CoreData
import SwiftUI

public struct TaskModel {

    private let moc: NSManagedObjectContext
    private (set) var tasks: [Tasks]?

    init (list: ListSet) {
        moc = PersistenceController.shared.container.viewContext
        tasks = list.tasksArray
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
