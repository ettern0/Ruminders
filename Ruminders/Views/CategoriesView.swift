
import SwiftUI

struct CategoriesView: View {

    @Binding var mode: EditMode
    var cvm: CategoryViewModel = CategoryViewModel.instance
    
    var body: some View {
        if mode == .inactive {
            gridView
        } else {
            List {
                ForEach(cvm.categoriesWithTasks, id: \.category) { element in
                    HStack {
                        Text(element.category.rawValue)
                        Text(String(element.tasks.count))
                    }
                }
            }
        }
    }

    var gridView: some View {

        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

        let widthOfElement = UIScreen.main.bounds.width / 2 * 0.88
        var needToExposeLastElement: Bool {
            cvm.categoriesWithTasks.count % 2 != 0
        }
        var lastElement: (category: Category, tasks: [Tasks]) {
            cvm.categoriesWithTasks.last!
        }

        return VStack {
            LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                ForEach(cvm.categoriesWithTasks, id: \.category) { element in

                    if needToExposeLastElement, element == lastElement { } else {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: widthOfElement, height: 80)
                            .foregroundColor(.white)
                            .overlay {
                                VStack {
                                    HStack {
                                        getSignOfCategory(category: element.category)
                                        Spacer()
                                        Text(String(element.tasks.count))
                                    }
                                    HStack {
                                        Text(element.category.rawValue)
                                        Spacer()
                                    }
                                }
                                .padding()
                                .padding()
                            }
                    }
                }
            }
            .padding(.leading)
            .padding(.trailing)
            if needToExposeLastElement {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
                    .foregroundColor(.white)
                    .overlay {
                        VStack {
                            HStack {
                                getSignOfCategory(category: lastElement.category)
                                Spacer()
                                Text(String(lastElement.tasks.count))
                            }
                            HStack {
                                Text(lastElement.category.rawValue)
                                Spacer()
                            }
                        }
                        .padding()
                        .padding()
                    }
            }
        }
    }

    func getSignOfCategory(category: Category) -> some View {
        let signAndColor = getSignAndColor(category)
        return ZStack {
            Circle()
                .foregroundColor(signAndColor.color)
                .frame(width: 30, height: 30)
            Image(systemName: signAndColor.sign)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
        }
    }
}
