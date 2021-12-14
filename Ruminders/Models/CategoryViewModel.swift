
import SwiftUI

class CategoryViewModel {

    static let instance = CategoryViewModel()
    @Published var model: CategoryModel = CategoryModel()

    var categoriesWithTasks: [(category: Category, tasks: [Tasks])] {
        model.categoriesWithTasks
    }
    
}
