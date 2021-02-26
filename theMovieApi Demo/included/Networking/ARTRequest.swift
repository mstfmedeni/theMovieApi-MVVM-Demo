
import Alamofire


// Base URL
public let baseURL: String = "https://api.themoviedb.org/3/"

typealias RequestBlock<T> = (_ response:T?, _ error:APIErrorResponse?) -> Void

struct APIErrorResponse:ARTCodable {
    var status_code: Int?
    var success: Bool?
    var status_message: String?
}

struct ApiResult<T:ARTCodable>: ARTCodable {
    let set: T
}

enum RequestBodyType {
    case json
    case form
    //case list
}

class ARTRequest<M:ARTCodable> {
        
    var requestCount:Int = 1
    var path: String = ""
    var method: HTTPMethod = .get
    var body:ARTEncodable? = nil
    var bodyType:RequestBodyType = .json
    
    fileprivate let validCodes:[Int] = [200]
    fileprivate var resultHandler:RequestBlock<M>?
    
    fileprivate func isValid(responseCode:Int) -> Bool {
        return validCodes.firstIndex(of:responseCode) != nil
    }
    
    func send(timeout:TimeInterval? = nil, _ result:RequestBlock<M>?) {
        print("**** SENDING REQUEST ****")

        guard let url: URL = URL(string: path, relativeTo: URL(string: baseURL)) else {  result?(nil, .init(status_code: nil, success: false, status_message: "URL NOT VALID")); return }

        var request = URLRequest(url:url)
        request.httpMethod = method.rawValue
        #if DEBUG
        print(url.absoluteString)
        print("↓ REQUEST ↓")
        #endif
        if method != .get {
            if bodyType == .json, let data = body?.toData() {
                request.httpBody = data
                #if DEBUG
                if let str = NSString(data:data, encoding:4) {
                    print(str)
                }
                #endif
            }
        }
        #if DEBUG
        print("↑ REQUEST ↑")
        #endif
        let headers:[String:String] = [
                        "Content-Type": "application/json;charset=utf-8",
                        "Authorization":"Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0MTIxZDUzMGNmNTkyMGU0ZDAwOWNiMjExOGJmNzVkZSIsInN1YiI6IjYwMzgwNWVmYjViYzIxMDAzZGRlYTI5YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.rhQLBVKl3RZRiqvpOqzJV50s27Dx30xT-J8csNRqki0"
        ]


        request.allHTTPHeaderFields = headers
        resultHandler = result

            request.timeoutInterval = timeout ?? 20
            sendRequest(request)
     }
    
    
    fileprivate func sendRequest(_ request:URLRequest) {
        AF.request(request).validate(statusCode:validCodes).response(completionHandler:handleResponse(_:))
    }
   
    
    
    fileprivate func handleResponse(_ response:AFDataResponse<Data?>) -> Void {
        
        let responseCode:Int = response.response?.statusCode ?? 0
        if response.response == nil || !isValid(responseCode:responseCode) {
            let requestObject = self
            if requestObject.requestCount == 1 {
                #if DEBUG
                print("↓ ERROR RESPONSE ↓")
                if let data = response.data, let str = NSString(data:data, encoding:4) {
                    print(str)
                }
                print("↑ ERROR RESPONSE ↑")
                #endif
                requestObject.requestCount = 2
                requestObject.send(resultHandler)
                return
            }
        }
        
        guard let handler = resultHandler else {
            return
        }
        
        var responseObject:M? = nil
        var errorObject:APIErrorResponse? = nil
        if let data = response.data {
            #if DEBUG
            print("↓ RESPONSE ↓")
            if let str = NSString(data:data, encoding:4) {
                print(str)
            }
            print("↑ RESPONSE ↑")
            #endif
            
            if isValid(responseCode:responseCode) {
                responseObject = reflectModel(data:data)
            }
            else {
                errorObject = reflectModel(data:data)
            }
        }
        
        DispatchQueue.main.async {
            handler(responseObject, errorObject)
            //handler(responseObject, response.error)
            //self.resultHandler = nil
        }
    }
    
}
