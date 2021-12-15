
import SwiftUI

struct TaskContext: View {

    let tvm: TasksViewModel
    @State var task: TaskStruct
    @Binding var show: Bool
    @State var name: String = ""
    @State var notes: String = ""
    @State var url: String = ""

    @State var date: Date = .now
    @State var setADate: Bool = false

    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var setATime: Bool = false

    init (model: TasksViewModel, task: TaskStruct, show: Binding<Bool>) {

        self.tvm = model
        _task = .init(initialValue: task)
        _show = show

        if let index = tvm.tasks.firstIndex(of: task) {
            _name = .init(initialValue: tvm.tasks[index].name)
            _notes = .init(initialValue: tvm.tasks[index].notes)
            _url = .init(initialValue: tvm.tasks[index].url)

            if let date = tvm.tasks[index].scheduledDate {
                _date = .init(initialValue: date)
                _setADate = .init(initialValue: true)
            }
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            VStack(spacing: 10) {
                HStack {
                    backButton
                    Spacer()
                    Text("Details")
                    Spacer()
                    doneButton
                }
                .padding()
                mainInfo
            }
        }
    }

    var mainInfo: some View {
        List {
            Section() {
                TextField("", text: $name)
                TextField("Notes", text: $notes)
                TextField("URL", text: $url)
            }
            Section() {
                Toggle(isOn: $setADate) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.red)
                            Text("Date")
                        }
                    }
                }

                if setADate {
                    withAnimation {
                        DatePicker(
                            "Start Date",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                            .datePickerStyle(.graphical)
                    }
                }

                Toggle(isOn: $setATime) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text("Time")
                    }
                }
                if setATime {
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Picker(selection: $hours, label: Text("")) {
                            ForEach(0 ..< 24) { index in
                                Text("\(index) h").tag(index)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: 200, alignment: .center)
                        .compositingGroup()
                        .clipped()
                        //.padding(.leading, 20)

                        Picker(selection: $minutes, label: Text("")) {
                            ForEach(0 ..< 55) { index in
                                if index%5 == 0 {
                                Text("\(index) m").tag(index)
                            }
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: 200, alignment: .center)
                        .compositingGroup()
                        .clipped()
                        //.padding(.trailing, 20)
                        Spacer()
                    }
                }
            }
        }
    }


    var backButton: some View {
        Button {
            show.toggle()
        } label: {
            Text("Cancel")
        }
    }

    var doneButton: some View {
        Button {
            tvm.saveTask(task: task)
        } label: {
            Text("Done")
        }
    }
}
