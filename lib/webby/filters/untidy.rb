# Untidy, run this filter after a Tidy filter to clean
# up formatting that is not configurable in Tidy
Webby::Filters.register :untidy do |input|

  # compress multiple newlines to one
  input = input.gsub(/[\n]+/, "\n")
  
  # make sure </code></pre> is on one line (Markdown code)
  input = input.gsub(/\<\/code\>\n\<\/pre\>/, "</code></pre>")

end

# EOF
