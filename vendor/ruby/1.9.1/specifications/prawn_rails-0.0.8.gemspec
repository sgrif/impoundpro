# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "prawn_rails"
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Walton Hoops"]
  s.date = "2012-01-04"
  s.description = "The prawn_rails gem provides a Prawn based view engine for creating PDFs with rails."
  s.email = "me@waltonhoops.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://github.com/Volundr/prawn-rails"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Integrates Prawn into Rails in a natural way"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<prawn>, [">= 0.11.1"])
    else
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<prawn>, [">= 0.11.1"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<prawn>, [">= 0.11.1"])
  end
end