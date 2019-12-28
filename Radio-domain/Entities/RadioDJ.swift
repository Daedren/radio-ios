import Foundation

public class RadioDJ {
    public var id: Int
    public var name: String
    public var text: String
    public var image: URL
    public var color: Color
    public var visible: Bool
    public var priority: Int
    
    public init(
        id: Int,
        name: String,
        text: String,
        image: URL,
        color: Color,
        visible: Bool,
        priority: Int
    ){
        self.id = id
        self.name = name
        self.text = text
        self.image = image
        self.color = color
        self.visible = visible
        self.priority = priority
    }
}

public class Color {
    var red: Int
    var green: Int
    var blue: Int
    
    public init(
    red: Int,
    green: Int,
    blue: Int
    ) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}
