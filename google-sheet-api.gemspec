lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "google-sheet-api/version"

Gem::Specification.new do |spec|
  spec.name          = "google-sheet-api"
  spec.version       = GoogleSheetApi::VERSION
  spec.authors       = ["trex22"]
  spec.email         = ["contact@jasonchalom.com"]

  spec.summary       = "A client for using Google sheets and forms in pure Ruby."
  spec.description   = "A client for using Google sheets and forms in pure Ruby."
  spec.homepage      = "https://github.com/TRex22/google-sheet-api"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.add_dependency "httparty", "~> 0.21.0"

  # Development dependancies
  spec.add_development_dependency "pry", "~> 0.14.2"
end
