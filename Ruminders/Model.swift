
import CoreData
import SwiftUI

public struct ListsModel {

    private let viewContext: NSManagedObjectContext
    private (set) var lists: [ListSet]?
    private var modelRefresh: Bool = false

    init () {
        viewContext = PersistenceController.shared.container.viewContext
        getListFromData()
    }

    mutating func getListFromData() {

        let request = ListSet.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ListSet.position, ascending: true)
        ]
        let result = try? viewContext.fetch(request)
        self.lists = result
        modelRefresh.toggle()

    }

    mutating func save(list: ListSet?,
                      name: String,
                      picture: String,
                      hasSysName: Bool,
                      color: Color,
                       position: Int) {
        let item = list ?? ListSet(context: viewContext)
        item.timestamp = Date()
        item.name = name
        item.picture = picture
        item.thePictureHasSystemName = hasSysName
        item.color = getUIDataFromColor(color: color)
        item.position = Int32(position)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        getListFromData()
    }

    mutating func delete(list: ListSet) {
        viewContext.delete(list)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        getListFromData()
    }
}
