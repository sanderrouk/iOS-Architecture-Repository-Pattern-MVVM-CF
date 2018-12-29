import Promises

protocol TodoRepository: TodoDataSource, Repository {
    func saveOrUpdate(todos: [Todo]) -> Promise<[Todo]>
}

final class TodoRepositoryImpl: TodoRepository {

    func getTodos() -> Promise<[Todo]> {
        return openRealm()
            .then { realm in
                return Array(realm.objects(Todo.self))
        }
    }

    func saveOrUpdate(todo: Todo) -> Promise<Todo> {
        return openRealm()
            .then { realm in
                try realm.write {
                    realm.add(todo, update: true)
                }
                return Promise(todo)
        }
    }

    func saveOrUpdate(todos: [Todo]) -> Promise<[Todo]> {
        return openRealm()
            .then { realm in
                try realm.write {
                    realm.add(todos, update: true)
                }
                return Promise(todos)
        }
    }
}
