//
//  GeneralFunctions.swift
//  Ruminders
//
//  Created by Евгений Сердюков on 24.10.2021.
//

import Foundation
import SwiftUI
import CoreData


func getUIDataFromColor(color: Color) -> Data {
    //    do {
    //        try obj.color = NSKeyedArchiver.archivedData(withRootObject: UIColor.blue, requiringSecureCoding: false)
    //    } catch {
    //        print(error)
    //    }

    do {
        return try NSKeyedArchiver.archivedData(withRootObject: UIColor(color), requiringSecureCoding: false)
    } catch {
        return Data()
    }
}


func getColor(data: Data) -> Color {
    do {
        return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)!)
    } catch {
        print(error)
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
    func endEditing(_ force: Bool) {
        UIApplication.shared.keyWindow?.endEditing(force)
    }
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

//*Emoji keyBoard
struct EmojiTF: View {
    @Binding var emojiText: String

    init(emojiText:  Binding<String>) {
        self._emojiText = emojiText
    }

    var body: some View {
            ZStack {
                Text("😄")
                TextFieldWrapperView(text: self._emojiText)
                    .frame(width: 5, height: 5, alignment: .center)
                    .background(Color(.red))
                    .opacity(0.1)
            }
    }
}

struct TextFieldWrapperView: UIViewRepresentable {
    @Binding var text: String
    func makeCoordinator() -> TFCoordinator {
        TFCoordinator(self)
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

