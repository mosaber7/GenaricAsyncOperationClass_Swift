import Foundation
import UIKit

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

// Mark: - operation Example

class ImageDownloadOperation: GenaricAsyncOperation{
    private let url: URL
    var image: UIImage?
    init(url: URL) {
        self.url = url
        super.init()
    }
    override func main() {
        URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
            
            guard let self = self else {
                return
            }
            //called after the return to modify the state of the operation from .executing -> .finished
            defer {
                self.state = .finished
            }
            guard let error = error,let data = data else {
                return
            }
            self.image = UIImage(data: data)
        }.resume()
    }
    
}
