import Foundation

class SearchRequest: APIRequest {
    public typealias Response = SearchResponseModel
    
    var searchTerm: String
    
    public var path: String {
        return "api/search/\(searchTerm)"
    }
    public var method: HTTPMethod {
        return .get
    }

    init(term: String){
        self.searchTerm = term
    }

}
