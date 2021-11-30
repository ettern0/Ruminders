//
//  ListRowView.swift
//  Ruminders
//
//  Created by Евгений Сердюков on 26.10.2021.
//

import SwiftUI

struct ListRowView: View {

    @ObservedObject var listsViewModel: ListsViewModel = ListsViewModel.instance
    var list: Ruminders.ListSet

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
                    Text("0")
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.gray)
            }
            .overlay {
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .opacity(0.1)
            }
        }
}
