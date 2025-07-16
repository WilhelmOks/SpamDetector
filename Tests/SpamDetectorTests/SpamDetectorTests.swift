import Testing
import Foundation
@testable import SpamDetector

func withConfig(_ config: SpamDetector.Config) async throws {
    let detector = SpamDetector(config: config)
    
    //TODO: tests with substrings
    
    let urlResults = examplesWithUrls.map { detector.check($0) }
    #expect(urlResults.allSatisfy { $0.isSpam })
    
    let phoneNumberResults = examplesWithPhoneNumbers.map { detector.check($0) }
    #expect(phoneNumberResults.allSatisfy { $0.isSpam })
    
    let notSpamResults = examplesWithoutSpam.map { detector.check($0) }
    #expect(notSpamResults.allSatisfy { !$0.isSpam })
}

@Test func fromLocalFile() async throws {
    let url = Bundle.module.url(forResource: "test_config", withExtension: "json")!
    let config = SpamDetector.Config.fromLocalFileUrl(jsonUrl: url)!
    try await withConfig(config)
}

@Test func fromUrl() async throws {
    let config = await SpamDetector.Config.fromRemoteUrl(jsonUrl: "https://raw.githubusercontent.com/WilhelmOks/SpamDetector/refs/heads/main/Tests/SpamDetectorTests/test_config.json")!
    try await withConfig(config)
}

let examplesWithUrls: [String] = [
    "💰 You’ve been selected! Claim your gift now at h t t p s : / / w w w [.] free-stuff [.] com / claim",
    "Congrats! You’re a winner 🎉 Visit www dot winprize dot net before midnight!",
    "Unlock your credit score now: hxxp[:]//credit-checker[.]online",
    "Final notice. Your account has been locked. Go to secure-login(dot)net to restore access.",
    "Visit dealz [dot] xyz / promo2024 for an exclusive offer just for you. Limited time ⏰!",
]

let examplesWithPhoneNumbers: [String] = [
    "Get instant approval for your loan 💸 Call us now: + 1 ( 8 0 0 )  555 - 1 2 1 2",
    "Need cash fast? Contact a rep today: +44 [ ] 20 - 1234 - 5678",
    "You’re approved! Reach us at 8 0 0 - 4 5 6 - 7 8 9 0 (ask for extension 9)",
    "💬 Text “YES” to (7 7 7) - 8 8 8 - 9 9 9 9 to confirm your prize!",
    "Call n0w → + 91 dot 9 8 7 6 dot 5 4 3 2 1 0 and get your free consultation!",
]

let examplesWithoutSpam: [String] = [
    "Lorem Ipsum dolor sit amet.",
    "Hello, world!",
    "This is a sample text.",
]
