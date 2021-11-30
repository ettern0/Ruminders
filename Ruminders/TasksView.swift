import SwiftUI

struct TasksView: View {

    @Environment(\.managedObjectContext) private var viewContext

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Tasks.timestamp, ascending: true)],
//        animation: .default)
    //private var tasks: FetchedResults<Tasks>

    var body: some View {
        NavigationView {
            Text("test task")
            List {
                
            }
        }
    }
}
