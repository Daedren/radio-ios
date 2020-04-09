import Foundation

class GetTokenRequest: APIRequest {
    public typealias Response = String
    
//    var searchTerm: String
    
    public var path: String {
        return "/"
    }
    public var method: HTTPMethod {
        return .get
    }

//    init(term: String){
//        self.searchTerm = term
//    }

}
