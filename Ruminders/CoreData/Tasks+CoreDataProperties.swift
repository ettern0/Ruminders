
import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }
    
    @NSManaged public var done: Bool
    @NSManaged public var flag: Bool
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var url: String?
    @NSManaged public var scheduledDate: Date?
    @NSManaged public var scheduledHour: NSNumber?
    @NSManaged public var scheduledMinute: NSNumber?
    @NSManaged public var position: NSNumber?
    @NSManaged public var listSet: ListSet?

    public var wrappedPosition:Int32 {
        let intPosition = position ?? 0
        return Int32(truncating: intPosition)
    }

    public var wrappedHour:Int32 {
        let intHour = scheduledHour ?? 0
        return Int32(truncating: intHour)
    }

    public var wrappedMinute:Int32 {
        let intMinute = scheduledMinute ?? 0
        return Int32(truncating: intMinute)
    }
}

extension Tasks : Identifiable {

}
