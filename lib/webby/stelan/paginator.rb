# This code was originally written by Bruce Williams, and it is available
# as the Paginator gem. I've added a few helper methods and modifications so
# it plays a little more nicely with Webby. Specifically, a Webby::Resource
# can be given to the Page and used to generate links to the previous and
# next pages.
#
# Many thanks to Bruce Williams for letting me use his work. Drop him a note
# of praise scribbled on the back of a $100 bill. He'd appreciate it.

require 'forwardable'

module Webby
class Paginator
  
  include Enumerable

  class ArgumentError < ::ArgumentError; end
  class MissingCountError < ArgumentError; end
  class MissingSelectError < ArgumentError; end  
  
  attr_reader :per_page, :count, :resource, :filename, :directory
  
  # Instantiate a new Paginator object
  #
  # Provide:
  # * A total count of the number of objects to paginate
  # * The number of objects in each page
  # * A block that returns the array of items
  #   * The block is passed the item offset 
  #     (and the number of items to show per page, for
  #     convenience, if the arity is 2)
  def initialize(count, per_page, resource, &select)
    @count, @per_page, @resource = count, per_page, resource
    @meta_data = @resource._meta_data.dup
    @filename = @resource.filename
    @directory = @resource.directory
    unless select
      raise MissingSelectError, "Must provide block to select data for each page"
    end
    @select = select
  end
  
  # Total number of pages
  def number_of_pages
     (@count / @per_page).to_i + (@count % @per_page > 0 ? 1 : 0)
  end
  
  # First page object
  def first
    page 1
  end
  
  # Last page object
  def last
    page number_of_pages
  end
  
  def each
    1.upto(number_of_pages) do |number|
      yield page(number)
    end
  end
  
  # Retrieve page object by number
  def page(number)
    number = (n = number.to_i) > 0 ? n : 1
    Page.new(self, number, lambda { 
      offset = (number - 1) * @per_page
      args = [offset]
      args << @per_page if @select.arity == 2
      @select.call(*args)
    })
  end

  # Finalizer method that should be called when the paginator is finished
  def reset
    resource._reset(@meta_data)
  end
  
  # Page object
  #
  # Retrieves items for a page and provides metadata about the position
  # of the page in the paginator
  class Page
    
    include Enumerable
        
    attr_reader :number, :pager, :url
    
    def initialize(pager, number, select) #:nodoc:
      @pager, @number = pager, number
      @offset = (number - 1) * pager.per_page
      @select = select

      @pager.reset
      if number > 1
        if ::Webby.site.create_mode == 'directory'
          @pager.resource['directory'] = File.join(@pager.directory, number.to_s)
        else
          @pager.resource['filename'] = @pager.filename + number.to_s
        end
      end
      @url = @pager.resource.url
    end

    # Retrieve the items for this page
    # * Caches
    def items
      @items ||= @select.call
    end
    
    # Checks to see if there's a page before this one
    def prev?
      @number > 1
    end
    
    # Get previous page (if possible)
    def prev
      @pager.page(@number - 1) if prev?
    end
     
    # Checks to see if there's a page after this one
    def next?
      @number < @pager.number_of_pages
    end
     
    # Get next page (if possible)
    def next
      @pager.page(@number + 1) if next?
    end
     
    # The "item number" of the first item on this page
    def first_item_number
      1 + @offset
    end
     
    # The "item number" of the last item on this page
    def last_item_number
      if next?
        @offset + @pager.per_page
      else
        @pager.count
      end
    end
     
    def ==(other) #:nodoc:
      @pager == other.pager && self.number == other.number
    end
     
    def each(&block)
      items.each(&block)
    end
     
    def method_missing(meth, *args, &block) #:nodoc:
      if @pager.respond_to?(meth)
        @pager.__send__(meth, *args, &block)
      else
        super
      end
    end

  end
  
end  # class Paginator
end  # module Webby
