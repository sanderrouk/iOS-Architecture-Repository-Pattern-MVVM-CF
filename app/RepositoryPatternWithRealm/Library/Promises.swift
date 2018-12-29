import Promises

typealias Promises<T> = (local: Promise<T>, remote: Promise<T>)
