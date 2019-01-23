import UIKit

final class TodoCoordinator: Coordinator {

    private let todoService: TodoProvider

    init(todoService: TodoProvider) {
        self.todoService = todoService
    }

    func start() -> UIViewController {
        let vm = TodoViewModel(todoService: todoService)
        return UINavigationController(rootViewController: TodoViewController(viewModel: vm))
    }
}
