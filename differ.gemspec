# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{differ}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pieter Vande Bruggen"]
  s.date = %q{2009-03-29}
  s.email = %q{pvande@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "VERSION.yml", "lib/differ", "lib/differ/change.rb", "lib/differ/diff.rb", "lib/differ/format", "lib/differ/format/ascii.rb", "lib/differ/format/color.rb", "lib/differ/format/html.rb", "lib/differ/string.rb", "lib/differ.rb", "spec/differ", "spec/differ/change_spec.rb", "spec/differ/diff_spec.rb", "spec/differ/format", "spec/differ/format/ascii_spec.rb", "spec/differ/format/color_spec.rb", "spec/differ/format/html_spec.rb", "spec/differ/string_spec.rb", "spec/differ_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/pvande/differ}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A simple gem for generating string diffs}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
