
# Render text via markdown using the RDiscount library.
if try_require('rdiscount', 'rdiscount')

  Loquacious.configuration_for(:webby) {
    desc <<-__
      An array of options that will be passed to RDiscount when procesing
      content. See the RDiscount rdoc documentation for the list of available
      options.
    __
    markdown_options %w(smart)
  }

  Webby::Filters.register :markdown do |input|
    RDiscount.new(input, *Webby.site.markdown_options).to_html
  end

# Otherwise raise an error if the user tries to use markdown
else
  Webby::Filters.register :markdown do |input|
    raise Webby::Error, "'rdiscount' must be installed to use the markdown filter"
  end
end

# EOF
