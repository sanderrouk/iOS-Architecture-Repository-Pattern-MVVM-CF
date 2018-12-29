import Promises
import RealmSwift

protocol Repository {
    func openRealm() -> Promise<Realm>
}

extension Repository {
    func openRealm() -> Promise<Realm> {
        return Promise { fulfill, reject in
            do {
                let realm = try Realm()
                fulfill(realm)
            } catch let err {
                reject(err)
            }
        }
    }
}
