import SwiftUI
import Combine
#if canImport(UIKit)
    import UIKit
#endif

public final class DeviceOrientation: ObservableObject {
      public enum Orientation {
        case portrait
        case landscape
    }
    @Published var orientation: Orientation
    private var listener: AnyCancellable?
    public init() {
        orientation = .landscape
        listener = nil
        #if os(iOS)
            orientation = UIDevice.current.orientation.isLandscape ? .landscape : .portrait
            listener = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
                .compactMap { ($0.object as? UIDevice)?.orientation }
                .compactMap { deviceOrientation -> Orientation? in
                    if deviceOrientation.isPortrait {
                        return .portrait
                    } else if deviceOrientation.isLandscape {
                        return .landscape
                    } else {
                        return nil
                    }
                }
                .assign(to: \.orientation, on: self)
        #endif
    }
    deinit {
        listener?.cancel()
    }
}
