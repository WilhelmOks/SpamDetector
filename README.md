# SpamDetector

An SPM library to recognize if a text is spam.
This is intended to be used in forums, social media networks or other chats or messengers where users can post spam messages for advertisement or other malicious intents.

## Usage

The rules and logic for the spam detection are provided by a config in json format.

Here is an example:

```code:json
{
    // The minimum spam score that a text needs to have to be considered spam.
    "spam_score_threshold": 100,
    
    // If the user has a higher reputation than this value, the text is not considered spam.
    // Reputation can be anything that is an indicator of the user's credibility or trust, such as upvotes, likes or karma.
    // Can be omitted if there is no reputation system.
    "user_reputation_threshold": 10,
    
    "substrings": [
        {
            "substring": "crypto",
            "spam_score": 50
        },
        {
            "substring": "recover",
            "spam_score": 60
        },
    ],
    "regex": [
        {
            "regex": "(?i)(?:\\+|\\(?\\s*\\+?\\s*\\)?\\s*)?(?:(?:\\d|dot|plus)[\\s\\-\\.\\(\\)\\[\\]_]*){7,}",
            "description": "a phone number",
            "spam_score": 110,
        },
        {
            "regex": "(?ix)(?:h\\s*[tx]{2,3}\\s*p\\s*s?)(?:\\s*[:\\[\\(\\]\\)]*\\s*\\/\\/+|\\s+)(?:w\\s*w\\s*w\\s*[\\.\\[\\(])?\\s*[a-z0-9\\-]+(?:\\s*(?:\\.|\\[\\.\\]|\\(dot\\)|\\[dot\\]|dot)\\s*[a-z]{2,})(?:\\s*[\\/\\\\]\\S*)?",
            "description": "a url",
            "spam_score": 150,
        },
    ]
}
```

This config can be loaded from a local file or a remote resource via a URL:

```code:swift
if let url = Bundle.module.url(forResource: "test_config", withExtension: "json") {
    let config = SpamDetector.Config.fromLocalFileUrl(jsonUrl: url)
}
```

```code:swift
let config = await SpamDetector.Config.fromRemoteUrl(jsonUrl: "https://www.example.com/test_config.json")
```

Then you can create a `SpamDetector` instance and check text for spam:

```code:swift
let detector = SpamDetector(config: config)

let result = detector.check("This is a text message which might be spam.")

print(result.isSpam)
```

The result contains a property `isSpam` and details about what kind of spam evidence was detected.
