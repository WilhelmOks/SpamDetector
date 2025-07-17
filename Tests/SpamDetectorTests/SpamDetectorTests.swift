import Testing
import Foundation
@testable import SpamDetector

func withConfig(_ config: SpamDetector.Config) async throws {
    let detector = SpamDetector(config: config)
    
    let substringsResults = examplesWithSubstrings.map { detector.check($0) }
    #expect(substringsResults.allSatisfy { $0.isSpam })
    
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

/*
@Test func fromUrl() async throws {
    let config = await SpamDetector.Config.fromRemoteUrl(jsonUrl: "https://raw.githubusercontent.com/WilhelmOks/SpamDetector/refs/heads/main/Tests/SpamDetectorTests/test_config.json")!
    try await withConfig(config)
}*/

let examplesWithSubstrings: [String] = [
    "Your crypto wallet has been compromised in a recent cyber breach. Act now to recover your funds at securecrypto[.]io.",
    "New investment opportunity! Navigate the volatile bitcoin landscape with tools trusted by 200k users. Sign up today!",
    "Don’t let a hack ruin your financial future. Learn how to recover lost crypto in minutes with our expert help.",
    "Discover how bitcoin is reshaping the cyber world. Earn daily profits using our automated AI platform!",
    "You’ve lost access to your crypto wallet? No problem. We specialize in hack recovery — contact our support now.",
    "Explore the changing landscape of cyber threats. Secure your digital trust with our next-gen firewall.",
    "Recover your compromised bitcoin account in under 15 minutes. Our cyber team is standing by.",
    "The crypto market is evolving. Build trust with real-time AI signals and grow your assets safely.",
    "ALERT: Your device has been part of a cyber hack. Visit recovery-node[.]net now to clean your system and protect data.",
    "Get ahead of the financial landscape shift. Convert unused assets to bitcoin and earn passive income today!",
]

let examplesWithPhoneNumbers: [String] = [
    "Get instant approval for your loan 💸 Call us now: + 1 ( 8 0 0 )  555 - 1 2 1 2",
    "Need cash fast? Contact a rep today: +44 [ ] 20 - 1234 - 5678",
    "You’re approved! Reach us at 8 0 0 - 4 5 6 - 7 8 9 0 (ask for extension 9)",
    "💬 Text “YES” to (7 7 7) - 8 8 8 - 9 9 9 9 to confirm your prize!",
    "Call n0w → + 91 dot 9 8 7 6 dot 5 4 3 2 1 0 and get your free consultation!",
]

let examplesWithUrls: [String] = [
    "You’ve been selected! Claim your gift now at https: // www . free-stuff. com / claim",
    "Unlock your credit score now: hxxp[:]//credit-checker[.]online",
    "Visit http://www.example.com for more information.",
    "Visit http://www . example.com for more information.",
    "Visit http://www dot example.com for more information.",
    "Visit http://www (dot) example.com for more information.",
]

let examplesWithoutSpam: [String] = [
    "Lorem Ipsum dolor sit amet.",
    "Hello, world. Second sentence.",
    "This is a sample text.",
    "Cyberpunk is great!",
    "I have a lot of bitcoin!",
    "This is not a phone number 12345!",
    "Here is one number 12345 and here is another number 67890. None of them are phone numbers.",
]
