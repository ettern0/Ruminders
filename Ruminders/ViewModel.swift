
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

    func save(list: ListSet? = nil,
              name: String? = nil,
              picture: String? = nil,
              hasSysName: Bool? = nil,
              color: Color? = nil,
              position: Int? = nil) {

        var _name = ""
        if let name = name {
            _name = name
        } else if let name = list?.name {
            _name = name
        }

        var _picture = ""
        if let picture = picture {
            _picture = picture
        } else if let picture = list?.picture {
            _picture = picture
        }

        var _color = Color(.white)
        if let color = color {
            _color = color
        } else if let color = list?.color {
            _color = getColor(data: color)
        }

        var _position = 0
        if let position = position {
            _position = position
        } else if let position = list?.position {
            _position = Int(position)
        }

        model.save(list: list,
                   name: _name,
                   picture: _picture,
                   hasSysName: true,
                   color: _color,
                   position: _position)
    }

    func delete(list: ListSet) {
        model.delete(list: list)
    }
}
