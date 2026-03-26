# frozen_string_literal: true

require "unicode/emoji"

module EmojiValidator
  class Validator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      return if value.blank? && options[:allow_blank]
      return if value.nil? && options[:allow_nil]
      
      string = value.to_s.strip
      
      unless valid_emoji_string?(string)
        record.errors.add(attribute, :invalid, message: error_message)
      end
    end
    
    private
    
    def valid_emoji_string?(string)
      return false if string.empty?
      
      allow_text = options[:allow_text]
      allow_multiple = options[:allow_multiple]
      
      if allow_text && allow_multiple
        # Can have text and multiple emojis
        string.match?(Unicode::Emoji::REGEX)
      elsif allow_text
        # Can have text but only one emoji
        emojis = string.scan(Unicode::Emoji::REGEX)
        emojis.length == 1
      elsif allow_multiple
        # Multiple emojis only, no text
        emoji_only_string?(string)
      else
        # Single emoji only, no text (default)
        string.match?(/\A#{Unicode::Emoji::REGEX}\z/)
      end
    end
    
    def emoji_only_string?(string)
      # Remove all emojis and check if anything non-whitespace remains
      remaining = string.gsub(Unicode::Emoji::REGEX, "")
      remaining.strip.empty? && string.match?(Unicode::Emoji::REGEX)
    end
    
    def error_message
      options[:message] || default_error_message
    end
    
    def default_error_message
      allow_text = options[:allow_text]
      allow_multiple = options[:allow_multiple]
      
      if allow_text && allow_multiple
        "must contain at least one emoji"
      elsif allow_text
        "must contain exactly one emoji"
      elsif allow_multiple
        "must contain only emojis"
      else
        "must be a single emoji"
      end
    end
  end
end