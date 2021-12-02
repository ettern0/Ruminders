
import Foundation
import SwiftUI
import CoreData

func getUIDataFromColor(color: Color) -> Data {

    do {
        return try NSKeyedArchiver.archivedData(withRootObject: UIColor(color), requiringSecureCoding: false)
    } catch {
        return Data()
    }
}


func getColor(data: Data?) -> Color {

    if let data = data {
        do {
            return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)!)
        } catch {
            print(error)
        }
    } else {
        return Color.random
    }

    return Color.clear
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

extension View {
//    func endEditing(_ force: Bool) {
//        UIApplication.shared.keyWindow?.endEditing(force)
//    }
}

class UIEmojiTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setEmoji() {
        _ = self.textInputMode
    }

    override var textInputContextIdentifier: String? {
           return ""
    }

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                self.keyboardType = .default // do not remove this
                return mode
            }
        }
        return nil
    }
}

struct EmodjiType: View {
    @State var searchText: String = ""
    @Binding var test: String

    var body: some View {
        NavigationView {
            EmptyView()
                .navigationBarItems(leading: TextField("Placeholder", text: self.$searchText))
        }
    }
}

//*Emoji keyBoard
struct EmojiTF: View {

    @State var emojiText: String = ""

    var body: some View {
            ZStack {
                Text("😄")
                TextFieldWrapperView(text: $emojiText)
                    .frame(width: 15, height: 15, alignment: .center)
                    .background(Color(.red))
                    .opacity(0.1)
            }
    }
}

struct TextFieldWrapperView: UIViewRepresentable {
    @Binding var text: String
    func makeCoordinator() -> TFCoordinator {
        return TFCoordinator(self)

    }
}

extension TextFieldWrapperView {

    func makeUIView(context: UIViewRepresentableContext<TextFieldWrapperView>) -> UITextField {
        let textField = EmojiTextField()
        textField.delegate = context.coordinator
        return textField
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
    }
}

class TFCoordinator: NSObject, UITextFieldDelegate {
    var parent: TextFieldWrapperView

    init(_ textField: TextFieldWrapperView) {
        self.parent = textField
    }
}

class EmojiTextField: UITextField {

    // required for iOS 13
    override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}

