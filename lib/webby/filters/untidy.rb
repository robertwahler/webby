# Untidy, run this filter after a Tidy filter to clean
# up formatting that is not configurable in Tidy
Webby::Filters.register :untidy do |input|

  # remove extra newlines between list items
  input = input.gsub(/<\/li>[\n]+(\s*)<li/, "</li>\n\\1<li")
  
  # make sure </code></pre> is on one line (Markdown code)
  input = input.gsub(/\<\/code\>\n\<\/pre\>/, "</code></pre>")

end

# EOF
