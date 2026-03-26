# frozen_string_literal: true

module EmojiValidator
  if defined?(Rails)
    class Engine < ::Rails::Engine
      isolate_namespace EmojiValidator
    end
  end
end