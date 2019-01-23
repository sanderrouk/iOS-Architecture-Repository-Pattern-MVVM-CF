// As the projects carthage was broken I copied the source into this project.
// This is not my work and is from https://github.com/roberthein/Observable/blob/master/Observable/Classes/Disposable.swift

import Foundation

public typealias Disposal = [Disposable]

public final class Disposable {

    private let dispose: () -> ()

    init(_ dispose: @escaping () -> ()) {
        self.dispose = dispose
    }

    deinit {
        dispose()
    }

    public func add(to disposal: inout Disposal) {
        disposal.append(self)
    }
}
