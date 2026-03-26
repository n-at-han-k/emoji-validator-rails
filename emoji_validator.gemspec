# frozen_string_literal: true

require_relative "lib/emoji_validator/version"

Gem::Specification.new do |spec|
  spec.name        = "emoji_validator"
  spec.version     = EmojiValidator::VERSION
  spec.authors     = ["Nathan Kidd"]
  spec.email       = ["nathankidd@hey.com"]
  spec.homepage    = "https://github.com/n-at-han-k/emoji-validator"
  spec.summary     = "Rails validator for emoji strings"
  spec.description = "A Rails engine that provides validators to check if strings contain emojis using the unicode-emoji gem."
  spec.license     = "Apache-2.0"

  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "rails",           ">= 7.0"
  spec.add_dependency "unicode-emoji",   "~> 4.0"
end
