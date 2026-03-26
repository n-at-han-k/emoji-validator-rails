# frozen_string_literal: true

module EmojiValidator
  # Validates that an attribute does NOT contain any emojis
  #
  #   class Person < ApplicationRecord
  #     validates :first_name, no_emoji: true
  #   end
  #
  #   person = Person.new(first_name: "John", last_name: "😃")
  #   person.valid? # true
  #   person.first_name = "😃"
  #   person.valid? # false
  #
  class NoEmojiValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      return if value.nil?
      return if value.to_s.match(Unicode::Emoji::REGEX).nil?

      record.errors.add(attribute, :has_emojis, message: options[:message] || "cannot contain emojis")
    end
  end
end
