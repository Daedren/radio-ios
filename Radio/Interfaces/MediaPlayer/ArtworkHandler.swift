import Foundation
import Combine
import Kingfisher
import SwiftUI
import KingfisherSwiftUI
import MediaPlayer

class ArtworkHandler {
    
    var artwork: MPMediaItemArtwork?
    private var artworkImage: UIImage?
    private var artworkDisposeBag = Set<AnyCancellable>()
    
    func getImageFromSize(size: CGSize) -> UIImage {
        // Thanks https://iosdevcenters.blogspot.com/2015/12/how-to-resize-image-in-swift-in-ios.html
        guard let image = self.artworkImage else { return UIImage() }
        let currentSize = image.size
        
        let widthRatio  = size.width  / currentSize.width
        let heightRatio = size.height / currentSize.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: currentSize.width * heightRatio, height: currentSize.height * heightRatio)
        } else {
            newSize = CGSize(width: currentSize.width * widthRatio,  height: currentSize.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
    
    func prepareArtworkFromDJ(url: URL) {
        self.artworkDisposeBag = Set<AnyCancellable>()
        self.getImageFromURL(url)
    }
    
    func getImageFromURL(_ url: URL) {
        KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: url), completionHandler: { [unowned self] result in
            switch result {
            case .success(let image):
                self.artworkImage = image.image
                self.artwork = MPMediaItemArtwork.init(boundsSize: image.image.size, requestHandler: self.getImageFromSize(size:))
            case .failure(let error):
                print(error)
            }
        })
            
    }
    
}
