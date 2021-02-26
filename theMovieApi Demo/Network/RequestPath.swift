
import Foundation


class RequestPath {
    
    static func nowPlaying() -> String {
        return "movie/now_playing"
    }

    static func upComing() -> String {
        return "movie/upcoming"
    }

    static func search(keyword:String) -> String {
        guard let keywordEncoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return ""}
        return "search/movie?query=\(keywordEncoded)"
    }

    static func detail(id:Int) -> String {
        return "movie/\(id)"
    }

    static func similarMovie(id:Int) -> String {
        return "movie/\(id)/similar"
    }    
    
}

