import Foundation
import Promises

protocol TodoViewModelView: AnyObject {
    func reloadView()
}

final class TodoViewModel {

    private let todoService: TodoService

    private var todos = [Todo]()

    weak var view: TodoViewModelView?

    init(todoService: TodoService) {
        self.todoService = todoService
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

    private func fetch() {
        let promises = todoService.getTodos()
        handleTodoFetch(promises.local)
        handleTodoFetch(promises.remote)
    }

    private func handleTodoFetch(_ promise: Promise<[Todo]>) {
        promise.then { [weak self] in
            self?.todos = $0
            self?.view?.reloadView()
        }.catch { print($0.localizedDescription) }
    }
}
