
public struct Config: Decodable {
    /// The minimum spam score that a text needs to have to be considered spam.
    public let spamScoreThreshold: Int
    
    /// If the user has a higher reputation than this value, the text is not considered spam.
    /// Reputation can be anything that is an indicator of the user's credibility or trust, such as upvotes, likes or karma.
    /// Can be omitted if there is no reputation system.
    public let userReputationThreshold: Int?
    
    public let substrings: [Substring]?
    public let regex: [Regex]?
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
