// As the projects carthage was broken I copied the source into this project.
// This is not my work and is from https://github.com/roberthein/Observable/blob/master/Observable/Classes/Lock.swift


import Foundation

// https://cocoawithlove.com/blog/2016/06/02/threads-and-mutexes.html
// http://www.vadimbulavin.com/atomic-properties/
// https://stackoverflow.com/a/47345863/976628
internal protocol Lock {
    func lock()
    func unlock()
}

internal final class Mutex: Lock {
    private var mutex: pthread_mutex_t = {
        var mutex = pthread_mutex_t()
        pthread_mutex_init(&mutex, nil)
        return mutex
    }()

    func lock() {
        pthread_mutex_lock(&mutex)
    }

    func unlock() {
        pthread_mutex_unlock(&mutex)
    }
}
