//
//  ListContext.swift
//  Ruminders
//
//  Created by Евгений Сердюков on 26.10.2021.
//

import SwiftUI

struct ListContext: View {
    @Environment(\.managedObjectContext) private var viewContext

    var list: ListSet?
    @State var color: Color
    @State var picture: String
    @State var thePictureHasSystemName: Bool
    @State var name: String
    @State var emojiText: String
    @State var nameIsEditing: Bool = false
    @FocusState private var emojiIsFocused: Bool
    @Binding var showListPropertiesItem: ListPropertiesState?

    let sizeOfRROfDescription = CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height/5)
    var sizeOfPictureDescription: CGSize { CGSize(width: sizeOfRROfDescription.width*0.2, height: sizeOfRROfDescription.height*0.2) }
    let colorsArray: Array<Color> = [.red, .orange, .yellow, .green, .blue, .brown, .purple, .mint, .pink, .gray, .teal]
    let signArray: Array<String> = ["list.bullet", "pencil", "rectangle.and.pencil.and.ellipsis", "lasso", "scissors", "wand.and.rays", "paintbrush", "folder",
                                    "calendar", "bookmark", "paperclip", "command.circle", "delete.left", "network", "moon.stars.fill", "cloud.fill", "snowflake",
                                    "circle.hexagongrid.fill", "mic", "suit.heart", "star", "bell", "message", "phone"]

    init(list: ListSet?, show showListProperties:  Binding<ListPropertiesState?>) {

        self.list = list
        self._showListPropertiesItem = showListProperties

        if let color = list?.color {
            self.color = getColor(data: color)
        } else {
            self.color = Color.random
        }

        if let picture = list?.picture {
            self.picture = picture
        } else {
            self.picture = "list.bullet"
        }

        if let name = list?.name {
            self.name = name
        } else {
            self.name = ""
        }

        if let thePictureHasSystemName = list?.thePictureHasSystemName {
            self.thePictureHasSystemName = thePictureHasSystemName
        } else {
            thePictureHasSystemName = true
        }

        self.emojiText = ""
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    HStack {
                        backButton
                        Spacer()
                        Text("Properties")
                        Spacer()
                        doneButton
                    }
                    .padding()
                    descriptionView.padding(.bottom, -20)
                    colorChoiseView.padding(.bottom, -20)
                    signChoiseView
                }
            }
        }
        .navigationTitle("Properties")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: doneButton)
    }

    var colorAndSignOfListView: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
                .frame(width: sizeOfPictureDescription.width * 2, height: sizeOfPictureDescription.height * 2)
                .shadow(radius: 5)
            if thePictureHasSystemName {
                Image(systemName: picture)
                    .resizable()
                    .scaledToFit()
                    .frame(width: sizeOfPictureDescription.width, height: sizeOfPictureDescription.height)
                    .foregroundColor(.white)
            } else {
                Text(picture)
                    .font(.system(size: 60))
            }
        }
        .padding(.bottom)
    }

    var textDescriptionView: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: sizeOfRROfDescription.width*0.9, height: sizeOfRROfDescription.height/4)
            .foregroundColor(Color(.systemGroupedBackground))
            .overlay(alignment: .center) {
                HStack {
                    TextField("Name", text: $name) { isEditing in
                            self.nameIsEditing = isEditing
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(color)
                    Spacer()
                    if self.nameIsEditing && self.name != "" {
                        Button {
                            self.name = ""
                        } label: {
                        Image(systemName: "xmark.circle.fill")
                            .padding(.trailing)
                            .foregroundColor(Color(.init(gray: 0, alpha: 0.2)))
                        }
                    }
                }
            }
    }

    var descriptionView: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: sizeOfRROfDescription.width, height: sizeOfRROfDescription.height)
                .foregroundColor(.white)
                .padding(.all)
                .overlay {
                    VStack{
                        colorAndSignOfListView
                        textDescriptionView
                    }
                }
        }
    }

    var colorChoiseView: some View {

         let columns = [
            GridItem(.adaptive(minimum: 40))
         ]

        return RoundedRectangle(cornerRadius: 10)
            .frame(width: sizeOfRROfDescription.width, height: sizeOfRROfDescription.height*0.6)
            .foregroundColor(.white)
            .padding(.all)
            .overlay {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(colorsArray, id: \.self) { item in
                        Circle()
                            .foregroundColor(item)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                self.color = item
                            }
                    }
                }
                .frame(width: sizeOfRROfDescription.width*0.9, height: sizeOfRROfDescription.height*0.6)
            }
    }

    var signChoiseView: some View {

        let columns = [
            GridItem(.adaptive(minimum: 40))
        ]

        return RoundedRectangle(cornerRadius: 10)
            .frame(height: UIScreen.main.bounds.height/2)
            .foregroundColor(.white)
            .padding(.all)
            .overlay {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ZStack {
                            if !self.thePictureHasSystemName {
                            //if picture == "" {
                                TextField("", text: $picture)
                                    .focused($emojiIsFocused)
                                    .opacity(0)
                            }
                            Button {
                                self.picture = ""
                                self.thePictureHasSystemName = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
                                    self.emojiIsFocused = true
                                }
                            } label: {
                                Text("😄")
                            }
                        }

                        ForEach(signArray, id: \.self) { _sign in
                            Circle()
                                .foregroundColor(Color(.systemGroupedBackground))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: _sign)}
                                .onTapGesture {
                                    self.picture = _sign
                                    self.thePictureHasSystemName = true
                                }

                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal, 5)
                .frame(maxHeight: UIScreen.main.bounds.height/2 * 0.9)
            }

    }

    var backButton: some View {
        Button {
            showListPropertiesItem = nil
        } label: {
            Text("Cancel")
        }
    }

    var doneButton: some View {
        Button {
            saveList()
            showListPropertiesItem = nil
        } label: {
            Text("Done")
        }
    }

    private func saveList() {
        let item = list ?? ListSet(context: viewContext)
        item.timestamp = Date()
        item.name = self.name
        item.picture = picture
        item.thePictureHasSystemName = thePictureHasSystemName
        item.color = getUIDataFromColor(color: color)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
