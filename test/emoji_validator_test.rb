# frozen_string_literal: true

require "test_helper"

class EmojiValidator::ValidatorTest < Minitest::Test
  class SingleEmojiModel
    include ActiveModel::Validations
    attr_accessor :content
    validates :content, emoji: true
  end
  
  class AllowTextModel
    include ActiveModel::Validations
    attr_accessor :content
    validates :content, emoji: { allow_text: true }
  end
  
  class AllowMultipleModel
    include ActiveModel::Validations
    attr_accessor :content
    validates :content, emoji: { allow_multiple: true }
  end
  
  class AllowTextAndMultipleModel
    include ActiveModel::Validations
    attr_accessor :content
    validates :content, emoji: { allow_text: true, allow_multiple: true }
  end
  
  class AllowBlankModel
    include ActiveModel::Validations
    attr_accessor :content
    validates :content, emoji: { allow_blank: true, allow_nil: true }
  end

  # Default: Single emoji only
  def test_valid_single_emoji
    model = SingleEmojiModel.new
    model.content = "😀"
    assert model.valid?
  end
  
  def test_invalid_text_with_emoji
    model = SingleEmojiModel.new
    model.content = "Hello 😀"
    assert !model.valid?
    assert_equal ["must be a single emoji"], model.errors[:content]
  end
  
  def test_invalid_multiple_emojis
    model = SingleEmojiModel.new
    model.content = "😀😁"
    assert !model.valid?
  end
  
  def test_invalid_no_emoji
    model = SingleEmojiModel.new
    model.content = "Hello World"
    assert !model.valid?
  end
  
  # allow_text: true
  def test_allow_text_valid
    model = AllowTextModel.new
    model.content = "Hello 😀 World"
    assert model.valid?
  end
  
  def test_allow_text_only_emoji_still_valid
    model = AllowTextModel.new
    model.content = "😀"
    assert model.valid?
  end
  
  def test_allow_text_multiple_emojis_invalid
    model = AllowTextModel.new
    model.content = "😀😁"
    assert !model.valid?
    assert_equal ["must contain exactly one emoji"], model.errors[:content]
  end
  
  # allow_multiple: true
  def test_allow_multiple_valid
    model = AllowMultipleModel.new
    model.content = "😀😁🎉"
    assert model.valid?
  end
  
  def test_allow_multiple_single_emoji_valid
    model = AllowMultipleModel.new
    model.content = "😀"
    assert model.valid?
  end
  
  def test_allow_multiple_with_text_invalid
    model = AllowMultipleModel.new
    model.content = "😀 Hello"
    assert !model.valid?
    assert_equal ["must contain only emojis"], model.errors[:content]
  end
  
  # allow_text: true, allow_multiple: true
  def test_allow_both_valid
    model = AllowTextAndMultipleModel.new
    model.content = "Hello 😀 World 🎉"
    assert model.valid?
  end
  
  def test_allow_both_no_emoji_invalid
    model = AllowTextAndMultipleModel.new
    model.content = "Hello World"
    assert !model.valid?
    assert_equal ["must contain at least one emoji"], model.errors[:content]
  end
  
  # Options
  def test_allow_blank
    model = AllowBlankModel.new
    model.content = ""
    assert model.valid?
  end
  
  def test_allow_nil
    model = AllowBlankModel.new
    model.content = nil
    assert model.valid?
  end
  
  def test_emoji_with_skin_tone
    model = SingleEmojiModel.new
    model.content = "👋🏽"
    assert model.valid?
  end
end