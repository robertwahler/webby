# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  # avoid shelling out to run git every time the gemspec is evaluated
  #
  # @see spec/gemspec_spec.rb
  #
  gemfiles_cache = File.join(File.dirname(__FILE__), '.gemfiles')
  if File.exists?(gemfiles_cache)
    gemfiles = File.open(gemfiles_cache, "r") {|f| f.read}
    # normalize EOL
    gemfiles.gsub!(/\r\n/, "\n")
  else
    # .gemfiles missing, run 'rake gemfiles' to create it
    # falling back to 'git ls-files'"
    gemfiles = `git ls-files`
  end

  s.name = %q{webby}
  s.version = "0.9.5.0"
  s.platform    = Gem::Platform::RUBY
  s.authors = ["Tim Pease"]
  s.email = %q{tim.pease@gmail.com}
  s.homepage = %q{http://webby.rubyforge.org/}
  s.summary = %q{Awesome static website creation and management!}
  s.description = %q{*Webby* is a fantastic little website management system. It would be called a *content management system* if it were a bigger kid. But, it's just a runt with a special knack for transforming text. And that's really all it does - manages the legwork of turning text into something else, an *ASCII Alchemist* if you will.  Webby works by combining the contents of a *page* with a *layout* to produce HTML. The layout contains everything common to all the pages - HTML headers, navigation menu, footer, etc. - and the page contains just the information for that page. You can use your favorite markup language to write your pages; Webby supports quite a few.  Install Webby and try it out!}

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = %q{webby}

  s.add_dependency "hpricot", ">= 0.6.0"
  s.add_dependency "loquacious", ">= 1.3.0"
  s.add_dependency "rake", ">= 0.8.7"
  s.add_dependency "directory_watcher", ">= 1.1.2"
  s.add_dependency "launchy", ">= 0.3.2"
  s.add_dependency "logging", ">= 0.9.7"

  s.add_development_dependency "bundler", ">= 1.0.14"
  s.add_development_dependency "rspec", ">= 2.6.0"

  s.files        = gemfiles.split("\n")
  s.executables  = gemfiles.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_paths = ["lib"]

  s.rdoc_options = ["--main", "README.rdoc"]
end
