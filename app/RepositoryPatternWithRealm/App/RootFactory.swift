import UIKit

struct RootFactory {
    private let todo: TodoFactory

    init() {
        let http: RequestExecutor = HttpRequestExecutor()
        let networkingService = NetworkingService(requestExecutor: http)

        let localTodoRepository = LocalTodoRepositoryImpl()
        let todoService = TodoProviderImpl(remoteRepository: networkingService,
                                          localRepository: localTodoRepository)

        todo = TodoFactoryImpl(todoService: todoService)
    }

    func make(window: UIWindow) -> RootCoordinator {
        return RootCoordinator(window: window, todo: todo)
    }
}
