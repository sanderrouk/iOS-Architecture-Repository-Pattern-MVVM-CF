import Promises

protocol TodoProvider {
    var todos: ImmutableObservable<[Todo]> { get }
    func getTodos()
    func saveOrUpdate(todo: Todo) -> Promise<Todo>
}

protocol TodoRepository {
    func getTodos() -> Promise<[Todo]>
    func saveOrUpdate(todo: Todo) -> Promise<Todo>
}

final class TodoProviderImpl: TodoProvider {
    var todos: ImmutableObservable<[Todo]>
    private var _todos: Observable<[Todo]>

    private let remoteRepository: TodoRepository
    private let localRepository: LocalTodoRepository

    init(remoteRepository: TodoRepository, localRepository: LocalTodoRepository) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
        self._todos = Observable([])
        self.todos = _todos
    }

    func getTodos() {
        handleList(response: localRepository.getTodos())
        handleList(response: remoteGet())
    }

    func saveOrUpdate(todo: Todo) -> Promise<Todo> {
        return remoteRepository.saveOrUpdate(todo: todo)
            .then { [weak self] todo in
                _ = self?.localRepository.saveOrUpdate(todo: todo)
        }
    }

    private func remoteGet() -> Promise<[Todo]> {
        return remoteRepository.getTodos()
            .then { [weak self] in self?.localRepository.saveOrUpdate(todos: $0) }
            .then { [weak self] _ in
                guard let self = self else { throw MultiDataSourceError.failedSync }
                return self.localRepository.getTodos()
        }
    }

    private func handleList(response: Promise<[Todo]>) {
        response.then { [weak self] in self?._todos.value = $0 }
    }
}
