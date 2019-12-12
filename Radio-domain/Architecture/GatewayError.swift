import Foundation

public struct AnyError: Error { }

public class GatewayError: Error {
    public static let noInternet = AnyError()
}
