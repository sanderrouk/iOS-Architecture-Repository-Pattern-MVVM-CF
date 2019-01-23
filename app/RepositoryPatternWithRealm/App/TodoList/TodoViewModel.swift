import Foundation
import Promises

protocol TodoViewModelView: AnyObject {
    func reloadView()
}

final class TodoViewModel {

    private let todoService: TodoProvider

    private var todos = [Todo]()
    private var observer: Disposable?

    weak var view: TodoViewModelView?

    init(todoService: TodoProvider) {
        self.todoService = todoService
        bind()
        fetch()
    }

    func numberOfRows() -> Int {
        return todos.count
    }

    func itemForRow(at indexPath: IndexPath) -> Todo {
        return todos[indexPath.row]
    }

    func addTodo(todo: Todo) {
        todoService.saveOrUpdate(todo: todo)
            .then { [weak self] _ in
                self?.fetch()
        }.catch { print($0.localizedDescription) }
    }

    private func bind() {
        observer = todoService.todos.observe { [weak self] todos, _ in
            self?.todos = todos
            self?.view?.reloadView()
        }
    }

    private func fetch() {
        todoService.getTodos()
    }
}
