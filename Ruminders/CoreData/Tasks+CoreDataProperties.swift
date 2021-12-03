
import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }
    
    @NSManaged public var done: Bool
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var position: NSNumber?
    @NSManaged public var listSet: ListSet?

    public var wrappedPosition:Int32 {
        let intPosition = position ?? 0
        return Int32(intPosition)
    }
}

extension Tasks : Identifiable {

}
