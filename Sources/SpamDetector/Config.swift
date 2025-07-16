import Foundation

public struct Config: Decodable {
    /// The minimum spam score that a text needs to have to be considered spam.
    public let spamScoreThreshold: Int
    
    /// If the user has a higher reputation than this value, the text is not considered spam.
    /// Reputation can be anything that is an indicator of the user's credibility or trust, such as upvotes, likes or karma.
    /// Can be omitted if there is no reputation system.
    public let userReputationThreshold: Int?
    
    /// Substrings to search for and their respective spam scores.
    public let substrings: [Substring]?
    
    /// Regex to search for matches and their respective spam scores.
    public let regex: [Regex]?
    
    public static func fromBundle(jsonFileName: String) -> Self? {
        let fileNameParts = jsonFileName.split(maxSplits: 1, whereSeparator: { $0 == "." }).map { String($0) }
        let fileName = fileNameParts.first ?? jsonFileName
        let fileExtension = fileNameParts.last ?? ""
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: fileExtension) else { return nil }
        do {
            let contents = try Data(contentsOf: URL(filePath: filePath))
            return try Self.decode(contents)
        } catch {
            return nil
        }
    }
    
    public static func fromUrl(jsonFileUrl: String) async -> Self? {
        let session = URLSession(configuration: .ephemeral)
        guard let url = URL(string: jsonFileUrl) else { return nil }
        guard let contents = try? await session.data(for: .init(url: url)).0 else { return nil }
        return try? Self.decode(contents)
    }
    
    private static func decode(_ data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.allowsJSON5 = true
        return try decoder.decode(Config.self, from: data)
    }
}

public extension Config {
    struct Substring: Decodable {
        /// If the text contains this substring, the spam score will increase.
        /// The search is case insensitive.
        public let substring: String
        
        /// The spam score that will be added to the text if the substring appears in it.
        public let spamScore: Int
    }
}

public extension Config {
    struct Regex: Decodable {
        /// If the text contains a match with this regex, the spam score will increase.
        public let regex: String
        
        /// The spam score that will be added to the text if the regex finds a match in it.
        public let spamScore: Int
    }
}
