import RealmSwift
import Foundation

class Todo: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(title, forKey: .title)
        if id != 0 {
            try container.encode(id, forKey: .id)
        }
    }
}
