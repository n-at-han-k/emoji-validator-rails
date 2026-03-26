# EmojiValidator

A Rails engine that provides validators for emoji strings using the [unicode-emoji](https://github.com/janlelis/unicode-emoji) gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "emoji_validator"
```

And then execute:

```bash
bundle install
```

## Usage

### Default: Single Emoji Only

By default, the field must contain exactly one emoji (no text, no multiple emojis):

```ruby
class Reaction < ApplicationRecord
  validates :emoji, emoji: true
end
```

```ruby
reaction = Reaction.new

reaction.emoji = "😀"      # ✓ Valid
reaction.emoji = "👋🏽"     # ✓ Valid (with skin tone)
reaction.emoji = "Hello 😀" # ✗ Invalid - has text
reaction.emoji = "😀😁"    # ✗ Invalid - multiple emojis
```

### Options

#### `allow_text: true`

Allow text alongside the emoji (still only one emoji allowed):

```ruby
class Message < ApplicationRecord
  validates :content, emoji: { allow_text: true }
end
```

```ruby
message.content = "Hello 😀 World"  # ✓ Valid
message.content = "😀"              # ✓ Valid
message.content = "😀😁"            # ✗ Invalid - multiple emojis
```

#### `allow_multiple: true`

Allow multiple emojis (no text allowed):

```ruby
class StickerSet < ApplicationRecord
  validates :emojis, emoji: { allow_multiple: true }
end
```

```ruby
sticker.emojis = "😀😁🎉"     # ✓ Valid
sticker.emojis = "😀"          # ✓ Valid
sticker.emojis = "😀 Hello"    # ✗ Invalid - has text
```

#### Both Options

Allow multiple emojis with text:

```ruby
class Post < ApplicationRecord
  validates :content, emoji: { allow_text: true, allow_multiple: true }
end
```

```ruby
post.content = "🎉 Party time! 🎊"  # ✓ Valid
post.content = "Hello World"        # ✗ Invalid - no emoji
```

#### `allow_blank` / `allow_nil`

Allow empty strings or nil values:

```ruby
class OptionalReaction < ApplicationRecord
  validates :emoji, emoji: { allow_blank: true, allow_nil: true }
end
```

#### Custom Error Message

```ruby
class Reaction < ApplicationRecord
  validates :emoji, emoji: { message: "pick one emoji" }
end
```

### Disallowing Emojis

In addition to requiring emojis, you can also validate that fields do **not** contain emojis.

#### `no_emoji` - Validate single attributes

```ruby
class Person < ApplicationRecord
  validates :first_name, no_emoji: true
end
```

```ruby
person.first_name = "John"      # ✓ Valid
person.first_name = "😃John"    # ✗ Invalid - contains emoji
person.first_name = "Jo😃hn"    # ✗ Invalid - contains emoji
```

##### Custom Error Message

```ruby
class Person < ApplicationRecord
  validates :first_name, no_emoji: { message: "cannot contain emojis" }
end
```

#### `NoEmojiAnywhereValidator` - Validate all string/text columns

Automatically apply no-emoji validation to all string and text columns in your model:

```ruby
class Person < ApplicationRecord
  include EmojiValidator::NoEmojiAnywhereValidator
end
```

```ruby
person = Person.new(first_name: "😃", last_name: "😃")
person.valid? # false
person.errors.count # 2 (errors on both first_name and last_name)
```

## Emoji Support

This gem uses the `unicode-emoji` gem which supports:

- Basic Emoji (😀, 🎉, etc.)
- Emoji with skin tones (👋🏽, etc.)
- Emoji sequences (flags, keycaps, ZWJ sequences)
- And more!

See the [unicode-emoji documentation](https://github.com/janlelis/unicode-emoji) for more details.

## License

Apache-2.0