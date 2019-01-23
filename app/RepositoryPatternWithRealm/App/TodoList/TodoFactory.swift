protocol TodoFactory {
    func make() -> Coordinator
}

struct TodoFactoryImpl: TodoFactory {

    let todoService: TodoProvider

    func make() -> Coordinator {
        return TodoCoordinator(todoService: todoService)
    }
}
