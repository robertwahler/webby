
# Compress CSS or JS via YUI Compressor using the 'yui/compressor' library.
if try_require('yui/compressor')

  Webby::Filters.register :'yui-compress' do |input|
    YUI::JavaScriptCompressor.new(:munge => true).compress(input)
  end
  Webby::Filters.register :'yui-compress-safe' do |input|
    YUI::JavaScriptCompressor.new.compress(input)
  end
  Webby::Filters.register :'yui-compress-css' do |input|
    YUI::CssCompressor.new.compress(input)
  end

# Otherwise raise an error if the user tries to use these filters
else
  Webby::Filters.register :'yui-compress' do |input|
    raise Webby::Error, "'yui/compressor' must be installed to use the yui-compress filter"
  end
  Webby::Filters.register :'yui-compress-safe' do |input|
    raise Webby::Error, "'yui/compressor' must be installed to use the yui-compress-safe filter"
  end
  Webby::Filters.register :'yui-compress-css' do |input|
    raise Webby::Error, "'yui/compressor' must be installed to use the yui-compress-css filter"
  end
end

# EOF
