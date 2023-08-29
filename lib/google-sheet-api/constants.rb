module GoogleSheetApi
  module Constants
    CLEANUP_PATTERNS = [
      ["\n", ""],
      ["\r", ""],
    ].freeze

    NUMBER_REGEX = /\d{2,}/.freeze

    REDIRECT_LIMIT = 2
  end
end
