Gem::Specification.new do |s|
  s.name = "assert-url"
  s.version = "1.0.0"
  s.summary = "Semantical helpers to test your URLs in Ruby"
  s.description = s.summary
  s.authors = ["Lucas Tolchinsky"]
  s.email = ["lucas.tolchinsky@gmail.com"]
  s.homepage = "https://github.com/tonchis/assert-url"
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_development_dependency "cutest"
end
