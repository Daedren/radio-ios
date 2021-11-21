import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SwiftUI

//enum RadioColors: String {
//    case foregroundColor
//
//    func asUIColor() -> UIColor {
//        return UIColor(named: self.rawValue)!
//    }
//
//    func asColor() -> Color {
//        return Color(self.rawValue)
//    }
//}

public class RadioColors {
    public static var label: Color {
        #if os(watchOS)
        return Color.white
        #else
        return Color(.label)
        #endif
    }
    
    public static var systemBackground: Color {
        #if os(watchOS)
        return Color.black
        #else
        return Color(.systemBackground)
        #endif
    }

    public static var secondarySystemBackground: Color {
        #if os(watchOS)
        return Color.gray
        #else
        return Color(.secondarySystemBackground)
        #endif
    }
    
    public static var tertiarySystemBackground: Color {
        #if os(watchOS)
        return Color.gray
        #else
        return Color(.tertiarySystemBackground)
        #endif
    }

}
