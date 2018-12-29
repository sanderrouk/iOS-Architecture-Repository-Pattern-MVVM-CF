import UIKit

struct RootFactory {
    private let todo: TodoFactory

    init() {
        let http: RequestExecutor = HttpRequestExecutor()
        let networkingService = NetworkingService(requestExecutor: http)

        let todoRepository = TodoRepositoryImpl()
        let todoService = TodoServiceImpl(todoProvider: networkingService,
                                          todoRepository: todoRepository)

        todo = TodoFactoryImpl(todoService: todoService)
    }

    func make(window: UIWindow) -> RootCoordinator {
        return RootCoordinator(window: window, todo: todo)
    }
}
