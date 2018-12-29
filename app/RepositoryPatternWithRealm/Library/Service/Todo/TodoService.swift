import Promises

protocol TodoService {
    /// Promises are not ideal for this use case however they are lovely to consume.
    /// Currently the consumer will need to handle both promises independently.
    /// An alternative to the tuple would be a list then you could iterate over the promises.
    /// That would not be ideal either as it does not properly indicate the intent.
    /// A more powerful solution would be observables but in that case RxSwift is pretty good to incorporate.
    func getTodos() -> Promises<[Todo]>
    func saveOrUpdate(todo: Todo) -> Promise<Todo>
}

protocol TodoDataSource {
    func getTodos() -> Promise<[Todo]>
    func saveOrUpdate(todo: Todo) -> Promise<Todo>
}

final class TodoServiceImpl: TodoService {
    private let todoProvider: TodoProvider
    private let todoRepository: TodoRepository

    init(todoProvider: TodoProvider, todoRepository: TodoRepository) {
        self.todoProvider = todoProvider
        self.todoRepository = todoRepository
    }

    func getTodos() -> Promises<[Todo]> {
        let localData = todoRepository.getTodos()
        let remoteData = remoteGet()
        return (localData, remoteData)
    }

    func saveOrUpdate(todo: Todo) -> Promise<Todo> {
        return todoProvider.saveOrUpdate(todo: todo)
            .then { [weak self] todo in
                _ = self?.todoRepository.saveOrUpdate(todo: todo)
        }
    }

    private func remoteGet() -> Promise<[Todo]> {
        return todoProvider.getTodos()
            .then { [weak self] in self?.todoRepository.saveOrUpdate(todos: $0) }
            .then { [weak self] _ in
                guard let self = self else { throw MultiDataSourceError.failedSync }
                return self.todoRepository.getTodos()
        }
    }
}
