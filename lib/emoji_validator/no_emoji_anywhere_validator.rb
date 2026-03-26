# frozen_string_literal: true

module EmojiValidator
  # Validates all string and text attributes of an ActiveRecord::Base class
  # Include it in your model to automatically apply the validation
  #
  #   class Person < ActiveRecord::Base
  #     include EmojiValidator::NoEmojiAnywhereValidator
  #   end
  #
  #   person = Person.new(first_name: "😃", last_name: "😃")
  #   person.valid? # false
  #   person.errors.count # 2
  #
  module NoEmojiAnywhereValidator
    def self.included(base)
      base.class_eval do
        if respond_to?(:columns_hash)
          columns_hash.each do |column_name, column_info|
            next unless %i[string text].include?(column_info.type)

            validates column_name, no_emoji: true
          end
        end
      end
    end
  end
end
