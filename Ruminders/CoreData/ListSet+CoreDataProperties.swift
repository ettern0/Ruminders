
import Foundation
import CoreData


extension ListSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListSet> {
        return NSFetchRequest<ListSet>(entityName: "ListSet")
    }

    @NSManaged public var color: Data?
    @NSManaged public var name: String?
    @NSManaged public var picture: String?
    @NSManaged public var position: Int32
    @NSManaged public var thePictureHasSystemName: Bool
    @NSManaged public var timestamp: Date?
    @NSManaged public var tasks: NSSet?

    public var tasksArray: [Tasks] {
        let result = tasks as? Set<Tasks> ?? []
        return result.sorted { $0.wrappedPosition < $1.wrappedPosition }
    }

    public var tasksCount: Int {
        tasksArray.count
    }

}

// MARK: Generated accessors for tasks
extension ListSet {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Tasks)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Tasks)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension ListSet : Identifiable {

}
