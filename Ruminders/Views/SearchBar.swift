
import SwiftUI

struct SearchView: View {

    @Binding var searchText: String
    @Binding var showCancelButton: Bool

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("search", text: $searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    print("onCommit")
                }).foregroundColor(.primary)

                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(UIColor(red: 0.894, green: 0.89, blue: 0.918, alpha: 1)))
            .cornerRadius(10.0)

            if showCancelButton  {
                Button("Cancel") {
                    UIApplication.shared.endEditing(true)
                    self.searchText = ""
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .navigationBarHidden(showCancelButton)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var empty: Bool
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        if !empty {
            content.gesture(gesture)
        } else {
            content
        }
    }
}

extension View {
    func resignKeyboardOnDragGesture(empty: Bool) -> some View {
        modifier(ResignKeyboardOnDragGesture(empty: empty))
    }
}
