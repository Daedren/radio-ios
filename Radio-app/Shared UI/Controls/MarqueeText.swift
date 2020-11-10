import SwiftUI
import Radio_cross

// Based on https://www.reddit.com/r/SwiftUI/comments/ettnux/marquee_scrolling_text/ffqw45y/

public struct MarqueeText : View {
    var text = ""
    var font: Font
    var screenWidth: CGFloat = 0.0
    @State private var animate = false
    private let animationOne = Animation.linear(duration: 2.5).delay(3.5).repeatForever(autoreverses: false)
    
    public init(text: String, font: Font) {
        self.text = text
        self.font = font
        
        let currentDevice = WKInterfaceDevice.current()
        let bounds = currentDevice.screenBounds
        self.screenWidth = bounds.width
    }
    
    public var body : some View {
        return ZStack {
            GeometryReader { geometry in
                Text(self.text).lineLimit(1)
                    .font(self.font)
                    .offset(x: self.animate ? -geometry.size.width * 2 : 0)
                    .animation(self.animationOne)
                    .onAppear() {
                        if geometry.size.width < self.screenWidth {
                            self.animate = true
                        }
                    }
                    .fixedSize(horizontal: true, vertical: false)
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                
                Text(self.text).lineLimit(1)
                    .font(self.font)
                    .offset(x: self.animate ? 0 : geometry.size.width * 2)
                    .animation(self.animationOne)
                    .fixedSize(horizontal: true, vertical: false)
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }
}

struct MarqueeText_Previews: PreviewProvider {
    static var previews: some View {
        VStack (alignment: .leading) {
            MarqueeText(text: "This is a really long text my dude", font: .headline)
        }
        .frame(width: 100, height: 30)
        .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
    }
}
