import Promises
import RealmSwift

protocol RealmRepository {
    func openRealm() -> Promise<Realm>
}

extension RealmRepository {
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
