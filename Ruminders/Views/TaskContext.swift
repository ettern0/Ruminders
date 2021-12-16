
import SwiftUI

struct TaskContext: View {

    @ObservedObject var tvm: TasksViewModel
    @State var task: TaskStruct
    @Binding var show: Bool
    @State var name: String = ""
    @State var notes: String = ""
    @State var url: String = ""
    @State var scheduledDate: Date = .now
    @State var setADate: Bool = false
    @State var scheduledHour: Int32 = 0
    @State var scheduledMinute: Int32 = 0
    @State var setATime: Bool = false
    @State var flag: Bool = false

    init (model: TasksViewModel, task: TaskStruct, show: Binding<Bool>) {
        self.tvm = model
        _task = .init(initialValue: task)
        _show = show

        if let index = tvm.tasks.firstIndex(of: task) {
            _name = .init(initialValue: tvm.tasks[index].name)
            _notes = .init(initialValue: tvm.tasks[index].notes)
            _url = .init(initialValue: tvm.tasks[index].url)
            _flag = .init(initialValue: tvm.tasks[index].flag)

            if let date = tvm.tasks[index].scheduledDate {
                _scheduledDate = .init(initialValue: date)
                _setADate = .init(initialValue: true)
            }
            if let scheduledHour = tvm.tasks[index].scheduledHour {
                _scheduledHour = .init(initialValue: scheduledHour)
            }
            if let scheduledMinute = tvm.tasks[index].scheduledMinute {
                _scheduledMinute = .init(initialValue: scheduledMinute)
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
            mainSection
            dateAndTimeSection
            flagSection
        }
    }

    var mainSection: some View {
        Section {
            TextField("", text: $name)
            TextField("Notes", text: $notes)
            TextField("URL", text: $url)
        }
    }

    var dateAndTimeSection: some View {
        Section {
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
                        selection: $scheduledDate,
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
                    Picker(selection: $scheduledHour, label: Text("")) {
                        ForEach(0 ..< 24) { index in
                            Text("\(index) h").tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: UIScreen.main.bounds.width * 0.2, height: 200, alignment: .center)
                    .compositingGroup()
                    .clipped()
                    Picker(selection: $scheduledMinute, label: Text("")) {
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
                    Spacer()
                }
            }
        }
    }

    var flagSection: some View {
        Toggle("Flag", isOn: $flag)
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
            task.name = name
            task.notes = notes
            task.url = url
            task.flag = flag
            task.scheduledDate = scheduledDate
            task.scheduledHour = scheduledHour
            task.scheduledMinute = scheduledMinute
            tvm.saveTask(task: task)
            show.toggle()
        } label: {
            Text("Done")
        }
    }
}
