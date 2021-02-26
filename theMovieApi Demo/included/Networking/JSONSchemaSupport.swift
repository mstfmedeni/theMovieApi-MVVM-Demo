
import Foundation
import Alamofire

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    let formatter = DateFormatter()
    //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'ZZZZ"
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'ZZZZ"
    formatter.timeZone = TimeZone.current
    decoder.dateDecodingStrategy = .formatted(formatter)
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
}


typealias ARTCodable = ARTMappable & Codable 
typealias ARTEncodable = ARTEncoding & Encodable

protocol ARTCoding: class {
    init(coding dict: [String: Any])
}

protocol ARTEncoding {
    func toData() -> Data?
    func toDictionary() -> [String: Any]?
}


protocol ARTMappable {
    typealias T = Self
    static func createModel(data: Data) throws -> T
}

extension ARTMappable where T: Codable {
    static func createModel(data: Data) throws -> T {
        let decoder = JSONDecoder()
        let object = try decoder.decode(T.self, from: data)
        return object
    }
}

extension ARTMappable where T:ARTCoding {
    static func createModel(data: Data) throws -> T {
        if let decoded = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return T(coding: decoded)
        }
        let error = NSError(domain: "model.can.not.serialize", code: 0, userInfo: nil)
        throw error
    }
}

extension ARTMappable {
    static func createJson(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
        }
        return nil
    }
}


extension Array:ARTMappable where Element: ARTCoding {
    static func createModel(data: Data) throws -> T {
        if let decoded = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
            return decoded.map({ (dict) -> Element in
                return Element(coding: dict)
            })
        }
        let error = NSError(domain: "model.can.not.serialize", code: 0, userInfo: nil)
        throw error
    }
}


extension ARTEncoding where Self:Encodable {
    
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    func toDictionary() -> [String: Any]? {
        guard let data = toData() else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension Array:ARTEncoding where Element:Encodable {
    
    func toDictionary() -> [String : Any]? {
        guard let data = toData() else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    func toData() -> Data? {
        if JSONSerialization.isValidJSONObject(self) {
            return try? JSONSerialization.data(withJSONObject:self, options: [])
        }
        else {
            return try? JSONEncoder().encode(self)
        }
    }
}


func reflectModel<T:ARTMappable>(data: Data?) -> T? {
    guard let responseData = data else {
        return nil
    }
    
    do {
        return try T.createModel(data: responseData)
    } catch {
        print(error)
        return nil
    }
}
