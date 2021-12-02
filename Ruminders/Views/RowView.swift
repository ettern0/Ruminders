
import SwiftUI

struct ListRowView: View {

    @ObservedObject var listsViewModel: ListsViewModel = ListsViewModel.instance
    var list: Ruminders.ListSet
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
                    Text("0")
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
//        .overlay {
//            Rectangle()
//                .frame(height: 50)
//                .foregroundColor(.red)
//                .opacity(0.1)
//        }
    }
}

struct RowView: View {

    @ObservedObject var listsViewModel: ListsViewModel = ListsViewModel.instance
    var list: RowElement
    var mode: EditMode
    @Binding var show: ListPropertiesState?

    var picture: AnyView {
        if list.thePictureHasSystemName {
            return  AnyView(Image(systemName: list.picture))
        } else {
            return AnyView(Text(list.picture))
        }
    }

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundColor(list.color)
                picture
                    .foregroundColor(.white)
            }
            .frame(width: 30, height: 30, alignment: .leading)
            Text(list.name)
            Spacer()
            HStack {
                if mode == .inactive {
                    Text("0")
                    Image(systemName: "chevron.right")
                } else {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            show = .list(list.list)
                        }
                }
            }
           .foregroundColor(.gray)
        }
    }
}
