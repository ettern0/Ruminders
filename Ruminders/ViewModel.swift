
import SwiftUI

public class ListsViewModel: ObservableObject {

    static public let instance = ListsViewModel()
    @Published private (set) var model = ListsModel()

    var lists: [ListSet] {
        if let lists = model.lists {
            return lists
        } else {
            return []
        }
    }

    func save(list: ListSet?,
              name: String,
              picture: String,
              hasSysName: Bool,
              color: Color) {

        model.save(list: list,
                   name: name,
                   picture: picture,
                   hasSysName: hasSysName,
                   color: color)
    }

    func delete(list: ListSet) {
        model.delete(list: list)
    }
}
