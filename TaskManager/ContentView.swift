import SwiftUI

// Singleton pattern
class TaskManager {
    static let shared = TaskManager()
    
    private var tasks: [Task] = []
    
    private init() {}
    
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    func removeTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
    
    func getTasks() -> [Task] {
        return tasks
    }
    
    
}

// Builder pattern
class TaskBuilder {
    private var task: Task
    
    init() {
        self.task = Task()
    }
    
    func setTitle(_ title: String) -> TaskBuilder {
        task.title = title
        return self
    }
    
    func setDescription(_ description: String) -> TaskBuilder {
        task.description = description
        return self
    }
    
    func setDueDate(_ dueDate: Date) -> TaskBuilder {
        task.dueDate = dueDate
        return self
    }
    
    func build() -> Task {
        return task
    }
}

class Task: Identifiable {
    var id = UUID()
    var title: String?
    var description: String?
    var dueDate: Date?
    
    
}
// Factory pattern
protocol TaskFactory {
    func createTask() -> Task
}

class DefaultTaskFactory: TaskFactory {
    func createTask() -> Task {
        return Task()
    }
}

// Adapter pattern
class TaskAdapter {
    private var task: Task
    
    init(task: Task) {
        self.task = task
    }
    
    func getTitle() -> String? {
        return task.title
    }
    
    func getDescription() -> String? {
        return task.description
    }
    
    func getDueDate() -> Date? {
        return task.dueDate
    }
}

// Composite pattern
class TaskGroup {
    private var tasks: [Task] = []
    
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    func removeTask(_ task: Task) {
        tasks.removeAll { $0 === task }
    }
    
    
}

// Decorator pattern
protocol TaskDecorator {
    var task: Task { get }
    func getTitle() -> String?
    func getDescription() -> String?
    func getDueDate() -> Date?
}

class DueDateDecorator: TaskDecorator {
    private var base: Task
    
    init(base: Task) {
        self.base = base
    }
    
    var task: Task {
        return base
    }
    
    func getTitle() -> String? {
        return base.title
    }
    
    func getDescription() -> String? {
        return base.description
    }
    
    func getDueDate() -> Date? {
        
        return base.dueDate
    }
}

// Chain of Responsibility pattern
protocol TaskHandler {
    var nextHandler: TaskHandler? { get set }
    func handleTask(_ task: Task)
}

class TitleHandler: TaskHandler {
    var nextHandler: TaskHandler?
    
    func handleTask(_ task: Task) {
        if task.title == nil {
            // Handle missing title
        } else {
            nextHandler?.handleTask(task)
        }
    }
}

class DescriptionHandler: TaskHandler {
    var nextHandler: TaskHandler?
    
    func handleTask(_ task: Task) {
        if task.description == nil {
            // Handle missing description
        } else {
            nextHandler?.handleTask(task)
        }
    }
}

class DueDateHandler: TaskHandler {
    var nextHandler: TaskHandler?
    
    func handleTask(_ task: Task) {
        if task.dueDate == nil {
            // Handle missing due date
        } else {
            nextHandler?.handleTask(task)
        }
    }
}

// Strategy pattern
protocol TaskSortingStrategy {
    func sort(_ tasks: [Task]) -> [Task]
}

class TitleSortingStrategy: TaskSortingStrategy {
    func sort(_ tasks: [Task]) -> [Task] {
        return tasks.sorted { ($0.title ?? "") < ($1.title ?? "") }
    }
}

class DueDateSortingStrategy: TaskSortingStrategy {
    func sort(_ tasks: [Task]) -> [Task] {
        return tasks.sorted { ($0.dueDate ?? Date.distantPast) < ($1.dueDate ?? Date.distantPast) }
    }
}

// UI
struct ContentView: View {
    @State private var taskTitle = ""
    @State private var taskDescription = ""
    @State private var dueDate = Date()
    @State private var tasks: [Task] = []
    
    var body: some View {
        VStack {
            Text("Task Manager").font(.largeTitle).padding()
            
            VStack(alignment: .leading, spacing: 16) {
                TextField("Title", text: $taskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Description", text: $taskDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            .padding(.horizontal)
            
            Button(action: {
                // Add task logic
                let taskBuilder = TaskBuilder()
                let task = taskBuilder
                    .setTitle(taskTitle)
                    .setDescription(taskDescription)
                    .setDueDate(dueDate)
                    .build()
                
                TaskManager.shared.addTask(task)
                
                // Clear input fields
                taskTitle = ""
                taskDescription = ""
                dueDate = Date()
                
                // Refresh task list
                tasks = TaskManager.shared.getTasks()
            }) {
                Text("Add Task")
                    .font(.title2)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            List(tasks) { task in
                VStack(alignment: .leading) {
                    Text(task.title ?? "")
                        .font(.headline)
                    Text(task.description ?? "")
                        .font(.subheadline)
                    Text(task.dueDate?.description ?? "")
                        .font(.subheadline)
                }
            }
            
            Spacer()
        }
        .onAppear {
            tasks = TaskManager.shared.getTasks()
        }
    }
}
