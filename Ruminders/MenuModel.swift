//
//  MenuModel.swift
//  Ruminders
//
//  Created by Евгений Сердюков on 22.10.2021.
//

import Foundation
import SwiftUI


//DropDown menu
struct DropDownAction {
    var title: String
    var action: () -> ()
}

private struct DropDownButton: View {

    var actionModel: DropDownAction
    var select: (DropDownAction) -> ()

    var body: some View {
        Button(actionModel.title, action: {
            self.select(self.actionModel) })
            .foregroundColor(Color.black)
    }
}

private struct DropDownMenu: View {

    var menuActions: [DropDownAction]
    var select: (DropDownAction) -> ()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(menuActions, id: \.title) {
                DropDownButton(actionModel: $0, select: self.select)
            }
        }
        .foregroundColor(Color.white)
        .padding(.all, 10)
        .background(Color(.systemGroupedBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


private struct DropDownHeader: View {

    var title: String
    var action: () -> ()
    var expand: Bool

    var body: some View {
        Button(action: action, label: { Text(title) })
            .padding(.all, 10)
            .foregroundColor(.blue)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 10)
    }
}


struct DropDownView: View {

    var menuActions: [DropDownAction]
    @State var expand = false

    var body: some View {

        VStack(alignment: .leading) {
            DropDownHeader(title: "hekhkhky", action:{ self.expand.toggle() }, expand: expand)
            if expand {
                DropDownMenu(menuActions: menuActions, select: {
                    action in
                    action.action()
                    self.expand.toggle()
                })
            }
        }
        .animation(.spring(), value: expand)


    }

}

struct MenuModel_Previews: PreviewProvider {

    static let actions = [ DropDownAction(title: "1 action", action: { Text("fsddssdfsdf") }),
                           DropDownAction(title: "2 action", action: { }),
                           DropDownAction(title: "3 action", action: { }),
                           DropDownAction(title: "4 action", action: { }),
                           DropDownAction(title: "5 action", action: { })]

    static var previews: some View {
        DropDownView(menuActions: actions)
    }
}
