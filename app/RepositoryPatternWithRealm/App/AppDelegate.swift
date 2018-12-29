import UIKit
import RealmSwift

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private let rootFactory: RootFactory
    private let rootCoordinator: RootCoordinator

    override init() {
        let window = UIWindow()
        rootFactory = RootFactory()
        rootCoordinator = rootFactory.make(window: window)
        super.init()
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupRealm()
        rootCoordinator.start()
        return true
    }
}
