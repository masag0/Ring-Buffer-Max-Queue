require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @capacity = 8
    @length = 0
    @first_index = 0
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if @first_index + index >= @length
    @store[@first_index + index]
  end

  # O(1)
  def []=(index, value)
    @store[@first_index + index] = value
  end

  # O(1)
  def pop
    if  !(@length < 1)
      r = self[@length - 1]
      self[@length - 1] = nil
      @length -= 1
      r
    else
      raise "index out of bounds"
    end

  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if @length == @capacity
    @length += 1
    self[@length - 1] = val
    self
  end

  # O(n): has to shift over all the elements.
  def shift
    if !(@length < 1)
      r = self[0]
      for i in 0..@length - 2
        self[i] = self[i+1]
      end
      @length -= 1
      r
    else
      raise "index out of bounds"
    end

  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if @length == @capacity
    i = @length - 1
    while i >= 0
      self[i+1] = self[i]
      i -= 1
    end
    @length += 1
    self[0] = val
    self
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    old_store = @store
    @capacity = @capacity * 2
    @store = StaticArray.new(@capacity)
    for i in 0..@capacity
      @store[i] = old_store[i]
    end
  end
end
