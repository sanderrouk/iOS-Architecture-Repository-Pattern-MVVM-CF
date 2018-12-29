import UIKit

final class RootCoordinator {
    private let window: UIWindow
    private let todo: TodoFactory
    private var child: Coordinator?

    init(window: UIWindow, todo: TodoFactory) {
        self.window = window
        self.todo = todo
    }

    func start() {
        let c = todo.make()
        child = c
        window.rootViewController = c.start()
        window.makeKeyAndVisible()
    }
}
