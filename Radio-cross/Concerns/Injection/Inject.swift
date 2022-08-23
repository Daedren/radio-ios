import Foundation

public protocol Component{
    
}

//class Resolver {
//    static let shared = Resolver()
//    var factoryDict: [String: () -> Component] = [:]
//
////    func add<T: Component>(_ factory: @escaping @autoclosure () -> T) {
////        factoryDict[String(describing: T.self)] = factory
////    }
//    func add(type: Component.Type, _ factory: @escaping () -> Component) {
//            factoryDict[String(describing: type.self)] = factory
//    }
//
//    func resolve<T: Component>(_ type: T.Type) -> T {
//        factoryDict[String(describing: type)]!() as! T
//    }
//}
//
//@propertyWrapper
//struct Inject<T: Component> {
//    var component: T
//
//    init(){
//        self.component = Resolver.shared.resolve(T.self)
//    }
//
//    public var wrappedValue: T {
//        get { return component}
//        mutating set { component = newValue }
//    }
//}
//
//public protocol InjectionKey {
//
//    /// The associated type representing the type of the dependency injection key's value.
//    associatedtype Value
//
//    /// The default value for the dependency injection key.
//    static var currentValue: Self.Value { get set }
//}
//
///// Provides access to injected dependencies.
//struct InjectedValues {
//
//    /// This is only used as an accessor to the computed properties within extensions of `InjectedValues`.
//    private static var current = InjectedValues()
//
//    /// A static subscript for updating the `currentValue` of `InjectionKey` instances.
//    static subscript<K>(key: K.Type) -> K.Value where K : InjectionKey {
//        get { key.currentValue }
//        set { key.currentValue = newValue }
//    }
//
//    /// A static subscript accessor for updating and references dependencies directly.
//    static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
//        get { current[keyPath: keyPath] }
//        set { current[keyPath: keyPath] = newValue }
//    }
//}
//
//@propertyWrapper
//struct Injected<T> {
//    private let keyPath: WritableKeyPath<InjectedValues, T>
//    var wrappedValue: T {
//        get { InjectedValues[keyPath] }
//        set { InjectedValues[keyPath] = newValue }
//    }
//
//    init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
//        self.keyPath = keyPath
//    }
//}


@propertyWrapper
public struct Inject<Value> {
    public private(set) var wrappedValue: Value
    
    public init() {
        self.init(name: nil, resolver: nil)
    }
    
    public init(name: String? = nil, resolver: Resolver? = nil) {
        let resolver = resolver ?? InjectSettings.shared
        
        if resolver is EmptyResolver {
            fatalError("Make sure InjectSettings.resolver is set!")
        }

        
        guard let value = resolver.resolve(Value.self, name: name) else {
            fatalError("Could not resolve non-optional \(Value.self)")
        }
        
        wrappedValue = value
    }
    
    public init<Wrapped>(name: String? = nil, resolver: Resolver? = nil) where Value == Optional<Wrapped> {
        let resolver = resolver ?? InjectSettings.shared
        
        if resolver is EmptyResolver {
            fatalError("Make sure InjectSettings.resolver is set!")
        }
        
        wrappedValue = resolver.resolve(Wrapped.self, name: name)
    }
}

public struct InjectSettings {
    public static var shared: Resolver = Container()
}

public protocol Resolver {
    func resolve<T>(_ type: T.Type, name: String?) -> T?
    func register<T>(_ type: T.Type, name: String?, value: @escaping () -> T)
}

class EmptyResolver: Resolver {

    func resolve<T>(_ type: T.Type, name: String?) -> T? {
        return nil
    }
    func register<T>(_ type: T.Type, name: String?, value: @escaping () -> T) {
        
    }
}

public extension Resolver {
    func resolve<T>(_ type: T.Type) -> T? {
        self.resolve(type, name: nil)
    }
    func register<T>(_ type: T.Type, _ value: @escaping () -> T) {
        self.register(type, name: nil, value: value)
    }
}


public class Container: Resolver {
    public var registry = [String: (() -> Any)]()
    public var singleton = [String: Any]()
    
    public init() {
        
    }
    
    private func key(type: Any.Type, name: String? = nil) -> String {
        if let name = name {
            return key(type: type) + "#" + name
        } else {
            return String(describing: type)
        }
    }
    
    public func register<T>(_ type: T.Type, name: String?, value: @escaping () -> T) {
        registry[key(type: type, name: name)] = value
    }

    public func resolve<T>(_ type: T.Type, name: String?) -> T? {
        if let value = singleton[key(type: type, name: name)] {
            return value as? T
        } else if let value = registry[key(type: type, name: name)] {
          let resolved = value()
          singleton[key(type: type, name: name)] = resolved
          return resolved as? T
        }
        return nil
    }
}
