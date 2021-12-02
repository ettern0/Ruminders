import CoreData
import SwiftUI

public struct TaskModel {

    private let moc: NSManagedObjectContext
    private (set) var tasks: [Tasks]?
    var list: ListSet?

    init () {
        moc = PersistenceController.shared.container.viewContext
        getTasksFromData()
    }

    mutating func getTasksFromData() {

        let request = Tasks.fetchRequest()
       

    }

}
