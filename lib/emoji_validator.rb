# frozen_string_literal: true

require "active_model"
require "unicode/emoji"

require "emoji_validator/version"
require "emoji_validator/engine"
require "emoji_validator/validator"
require "emoji_validator/no_emoji_validator"
require "emoji_validator/no_emoji_anywhere_validator"

module EmojiValidator
end

ActiveModel::Validations::EmojiValidator = EmojiValidator::Validator
ActiveModel::Validations::NoEmojiValidator = EmojiValidator::NoEmojiValidator
ActiveModel::Validations::NoEmojiAnywhereValidator = EmojiValidator::NoEmojiAnywhereValidator
