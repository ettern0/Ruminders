import SwiftUI
import simd

struct TasksView: View {

    @ObservedObject var tvm: TasksViewModel
    let list: ListSet
    @State var rowIsActive: Bool = false

    init(list: ListSet) {
        self.list = list
        tvm = TasksViewModel(list: list)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            VStack {
                List {
                    Section(header: listHeader) {
                        ForEach(tvm.tasks) { element in
                            TaskRowView(model: tvm, task: element)
                        }
                    }
                    .onTapGesture {
                        rowIsActive = true
                    }
                }
                .onTapGesture {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if rowIsActive {
                            rowIsActive.toggle()
                        } else {
                            tvm.appendTaskOnPosition(position: Int32(tvm.tasks.count))
                        }
                    }
                }
            }
        }
    }

    var listHeader: some View {
        HStack {
            Text(list.name ?? "")
                .font(Font.largeTitle.weight(.bold))
                .foregroundColor(getColor(data: list.color))
        }
    }
}

