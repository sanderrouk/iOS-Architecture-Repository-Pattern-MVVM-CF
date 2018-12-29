import RealmSwift

func setupRealm() {
    let config = Realm.Configuration(
        schemaVersion: 1,
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {

            }
    })

    Realm.Configuration.defaultConfiguration = config

    let _ = try! Realm()
}
