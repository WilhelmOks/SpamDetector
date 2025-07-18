import Foundation

public struct SpamDetector {
    public let config: Config
    public let stripWhiteSpace: Bool
    
    public init(config: Config, stripWhiteSpace: Bool = false) {
        self.config = config
        self.stripWhiteSpace = stripWhiteSpace
    }
    
    public func check(_ text: String, userReputation: Int? = nil) -> Result {
        if let userReputation, let threshold = config.userReputationThreshold  {
            if userReputation > threshold {
                return .init(
                    isSpam: false,
                    details: .init(
                        foundSubstrings: [],
                        foundRegex: [],
                        skippedDueToHighReputation: true,
                        totalSpamScore: 0,
                        spamScoreThreshold: config.spamScoreThreshold
                    )
                )
            }
        }
        
        var text = text
        if stripWhiteSpace {
            text.removeAll { $0.isWhitespace }
        }
        
        var spamScore = 0
        
        var foundSubstrings: [Config.Substring] = []
        var foundRegex: [Config.Regex] = []
        
        for substring in config.substrings ?? [] {
            if text.localizedCaseInsensitiveContains(substring.substring) {
                foundSubstrings.append(substring)
                spamScore += substring.spamScore
            }
        }
        
        for regex in config.regex ?? [] {
            if let swiftRegex = try? Regex(regex.regex) {
                if (try? swiftRegex.firstMatch(in: text)) != nil {
                    spamScore += regex.spamScore
                    foundRegex.append(regex)
                }
            }
        }
        
        let result = Result(
            isSpam: spamScore >= config.spamScoreThreshold,
            details: .init(
                foundSubstrings: foundSubstrings,
                foundRegex: foundRegex,
                skippedDueToHighReputation: false,
                totalSpamScore: spamScore,
                spamScoreThreshold: config.spamScoreThreshold
            )
        )
        
        return result
    }
}

public extension SpamDetector {
    struct Result {
        public let isSpam: Bool
        public let details: Details
        
        public struct Details {
            public let foundSubstrings: [Config.Substring]
            public let foundRegex: [Config.Regex]
            public let skippedDueToHighReputation: Bool
            public let totalSpamScore: Int
            public let spamScoreThreshold: Int
        }
    }
}
