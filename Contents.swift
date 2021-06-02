import Foundation


class GenaricAsyncOperation: Operation{
    var state = AsyncState.ready{
        willSet {
            willChangeValue(forKey: state.key)
            willChangeValue(forKey: newValue.key)
        }
        didSet {
            didChangeValue(forKey: state.key)
            didChangeValue(forKey: oldValue.key)
        }
    }
    
    override var isReady: Bool {
        return state == .ready && super.isReady
    }
    override var isExecuting: Bool {
        return state == .executing && super.isExecuting
    }
    override var isFinished: Bool {
        return state == .finished && super.isFinished
    }
    override var isAsynchronous: Bool {
        true
    }
    override func cancel() {
        state = .finished
    }
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
}
extension GenaricAsyncOperation{
    enum AsyncState:String {
        case ready, executing, finished
        
        var key: String{
            return "is\(rawValue.capitalized)"
        }
        
    }
}
