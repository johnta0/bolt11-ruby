
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bolt11/version"

Gem::Specification.new do |spec|
  spec.name          = "bolt11"
  spec.version       = Bolt11::VERSION
  spec.authors       = ["johnta0"]
  spec.email         = ["j0hnta@protonmail.com"]

  spec.summary       = %q{Encode/decode lightning network payment invoice.}
  spec.description   = %q{Encode/decode lightning network payment invoice.}
  spec.homepage      = "https://github.com/johnta0/bolt11-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
