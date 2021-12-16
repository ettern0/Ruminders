
import SwiftUI

struct ListContext: View {

    @State var color: Color
    @State var picture: String
    @State var thePictureHasSystemName: Bool
    @State var name: String
    @State var emojiText: String
    @State var nameIsEditing: Bool = false
    @State var position: Int32
    @FocusState private var emojiIsFocused: Bool
    @Binding var showListPropertiesItem: ListPropertiesState?
    var list: ListSet?
    let listViewModel: ListsViewModel = ListsViewModel.instance
    let sizeOfRROfDescription = getSizeOfDescription()
    let sizeOfPictureDescription = getsizeOfPictureDescription()

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

        if let position = list?.position {
            self.position = position
        } else {
            position = Int32(listViewModel.lists.count + 1)
        }
        self.emojiText = ""
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
            GridItem(.adaptive(minimum: 40))]

        return RoundedRectangle(cornerRadius: 10)
            .frame(width: sizeOfRROfDescription.width, height: sizeOfRROfDescription.height*0.6)
            .foregroundColor(.white)
            .padding(.all)
            .overlay {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(getColorsArray(), id: \.self) { item in
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
            GridItem(.adaptive(minimum: 40))]

        return RoundedRectangle(cornerRadius: 10)
            .frame(height: UIScreen.main.bounds.height/2)
            .foregroundColor(.white)
            .padding(.all)
            .overlay {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(getSignArray(), id: \.self) { _sign in
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
            listViewModel.saveList(list: list,
                               name: name,
                               picture: picture,
                               hasSysName: thePictureHasSystemName,
                               color: color,
                               position: Int(position))
            showListPropertiesItem = nil
        } label: {
            Text("Done")
        }
        .disabled(name.isEmpty)
    }
}

func getSizeOfDescription() -> CGSize {
    CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height/5)
}

func getsizeOfPictureDescription() -> CGSize {
    CGSize(width: getSizeOfDescription().width*0.2, height: getSizeOfDescription().height*0.2)
}
