
import SwiftUI

public class ListsViewModel: ObservableObject {

    static public let instance = ListsViewModel()
    @Published private (set) var model = ListsModel()
    @Published private (set) var modelState: Bool = false

    var lists: [ListSet] {
        if let lists = model.lists {
            return lists
        } else {
            return []
        }
    }

    func refreshModelState() {
        self.modelState.toggle()
    }

    func saveList(list: ListSet? = nil,
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

        model.saveList(list: list,
                   name: _name,
                   picture: _picture,
                   hasSysName: true,
                   color: _color,
                   position: _position)
    }

    func deleteList(list: ListSet) {
        model.delete(list: list)
    }
}

func getSignArray() -> Array<String> {
    ["list.bullet", "pencil", "rectangle.and.pencil.and.ellipsis", "lasso","scissors", "wand.and.rays","paintbrush", "folder","calendar", "bookmark", "paperclip", "command.circle", "delete.left","network", "moon.stars.fill", "cloud.fill", "snowflake", "circle.hexagongrid.fill", "mic", "suit.heart", "star", "bell", "message", "phone"]
}

func getColorsArray() -> Array<Color> {
    [.red, .orange, .yellow, .green, .blue, .brown, .purple, .mint, .pink, .gray, .teal]
}
