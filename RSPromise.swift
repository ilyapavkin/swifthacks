import ReactiveSwift
import enum Result.NoError

class Promise<Value, Error: Swift.Error> {
    let sp: SignalProducer<Value, Error>
    private var started: (() -> Void)?;
    private var value: ((Value) -> Void)?;
    private var completed: (() -> Void)?;
    private var failed: ((Error) -> Void)?;
    
    init(_ task: @escaping (Signal<Value, Error>.Observer, Lifetime) -> Void) {
        self.sp = SignalProducer<Value, Error>(task);
    }
    
    deinit {
        sp
            .on(
                // starting: {},
                started: self.started,
                // event: { (Signal<Value, Error>.Event) in},
                failed: self.failed,
                completed: self.completed,
                // interrupted: {},
                // terminated: {},
                // disposed: {},
                value: self.value
                )
            .start();
    }
    
    @discardableResult func started(_ then: @escaping () -> Void) -> Promise<Value, Error> {
        self.started = then;
        return self
    }
    
    @discardableResult func value(_ then: @escaping (Value) -> Void) -> Promise<Value, Error> {
        self.value = then;
        return self
    }
    
    @discardableResult func completed(_ then: @escaping () -> Void) -> Promise<Value, Error> {
        self.completed = then;
        return self
    }
    
    @discardableResult func failed(_ then: @escaping (Error) -> Void) -> Promise<Value, Error> {
        self.failed = then;
        return self
    }
}
