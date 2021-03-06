import Promises
import Foundation

extension NetworkingService: TodoRepository {
    func getTodos() -> Promise<[Todo]> {
        return get(path: "todos")
            .then { try JSONDecoder().decode([Todo].self, from: $0) }
    }

    func saveOrUpdate(todo: Todo) -> Promise<Todo> {
        let data = try! JSONEncoder().encode(todo)
        return post(path: "todos", body: data)
            .then { try JSONDecoder().decode(Todo.self, from: $0) }
    }
}
