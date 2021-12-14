
import CoreData
import SwiftUI
import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

public struct CategoryModel {

    private let moc: NSManagedObjectContext

    init() {
        moc = PersistenceController.shared.container.viewContext
    }

    var categoriesWithTasks: [(Category, [Tasks])] {
        var todayTasks: [Tasks] = []
        var schelduedTasks: [Tasks] = []
        var allTasks: [Tasks] = []
        var flaggeTasks: [Tasks] = []
        var assignedTasks: [Tasks] = []

        let request = Tasks.fetchRequest()
        let fetchResult = try? moc.fetch(request)
        if let result = fetchResult {
            result.forEach { element in
                if element.timestamp?.startOfDay == Date.now.startOfDay {
                    todayTasks.append(element)
                }
                if element.timestamp != nil {
                    schelduedTasks.append(element)
                }
                if element.flag {
                    flaggeTasks.append(element)
                }
                allTasks.append(element)
            }
        }

        return [
            (Category.today, todayTasks),
            (Category.scheldued, schelduedTasks),
            (Category.all, allTasks),
            (Category.flagged, flaggeTasks),
            (Category.assigned, assignedTasks),
        ]
    }
}

enum Category: String {
    case today = "Today"
    case scheldued = "Sheldued"
    case all = "All"
    case flagged = "Flagged"
    case assigned = "Assigned to me"
}
