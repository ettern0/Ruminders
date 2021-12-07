
import CoreData
import SwiftUI

public struct ListsModel {

    private let moc: NSManagedObjectContext
    @FetchRequest(sortDescriptors: []) var list: FetchedResults<ListSet>

    private (set) var lists: [ListSet]?
    private var modelRefresh: Bool = false

    init () {
        moc = PersistenceController.shared.container.viewContext
        getListFromData()
    }

    mutating func getListFromData() {

        let request = ListSet.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ListSet.position, ascending: true)
        ]
        let result = try? moc.fetch(request)
        self.lists = result
        modelRefresh.toggle()

    }

    mutating func saveList(list: ListSet?,
                      name: String,
                      picture: String,
                      hasSysName: Bool,
                      color: Color,
                       position: Int) {
        let item = list ?? ListSet(context: moc)
        item.timestamp = Date()
        item.name = name
        item.picture = picture
        item.thePictureHasSystemName = hasSysName
        item.color = getUIDataFromColor(color: color)
        item.position = Int32(position)
        do {
            try moc.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        getListFromData()
    }

    mutating func delete(list: ListSet) {
        moc.delete(list)
        do {
            try moc.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        getListFromData()
    }
}

struct ListElement:Identifiable {

    var id: Int32
    let list: ListSet
    var name: String = ""
    var picture: String = ""
    var thePictureHasSystemName: Bool = true
    var color: Color = .white
    var position: Int32 = 0
    var isActive: States = .ianactive

    init(element: ListSet) {

        if let name = element.name {
            self.name = name
        }

        if let picture = element.picture {
            self.picture = picture
        }

        if let data = element.color {
            self.color = getColor(data: data)
        }

        self.thePictureHasSystemName = element.thePictureHasSystemName
        self.position = element.position
        self.list = element
        self.id = element.position

    }

    enum States {
        case ianactive, active
    }

}
