protocol TodoFactory {
    func make() -> Coordinator
}

struct TodoFactoryImpl: TodoFactory {

    let todoService: TodoService

    func make() -> Coordinator {
        return TodoCoordinator(todoService: todoService)
    }
}
