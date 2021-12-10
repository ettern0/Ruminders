
import SwiftUI

struct ListRowView: View {

    @ObservedObject var list: Ruminders.ListSet
    var mode: EditMode
    @Binding var show: ListPropertiesState?

    var color: Color {

        if let colorData = list.color {
            return getColor(data: colorData)
        } else {
            return Color(.white)
        }
    }

    var picture: AnyView {
        let picture = list.picture ?? ""
        if list.thePictureHasSystemName {
            return  AnyView(Image(systemName: picture))
        } else {
            return AnyView(Text(picture))
        }
    }

    var name: some View {
        Text(list.name ?? "")
    }

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundColor(color)
                picture
                    .foregroundColor(.white)
            }
            .frame(width: 30, height: 30, alignment: .leading)
            name
            Spacer()
            HStack {
                if mode == .inactive {
                    Text(String(list.tasksArray.count))
                    Image(systemName: "chevron.right")

                } else {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            show = .list(list)
                        }
                }
            }
            .foregroundColor(.gray)
        }
    }
}

