import Foundation

class RadioDJ {
    var id: Int
    var name: String
    var text: String
    var image: URL
    var color: Color
    var visible: Bool
    var priority: Int
    
    init(
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

class Color {
    var red: Int
    var green: Int
    var blue: Int
    
    init(
    red: Int,
    green: Int,
    blue: Int
    ) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}
