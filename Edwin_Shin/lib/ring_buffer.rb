require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @capacity = 8
    @length = 0
    @start_idx = 0
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if index >= @length
    @store[(@start_idx + index) % @capacity]
  end

  # O(1)
  def []=(index, val)
    @store[(@start_idx + index) % @capacity] = val
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

  # O(1) ammortized
  def push(val)
    resize! if @length == @capacity
    @length += 1
    self[@length - 1] = val
    self
  end

  # O(1)
  def shift
    if !(@length < 1)
      r = self[0]
      self[0] = nil
      @start_idx += 1
      @length -= 1
      r
    else
      raise "index out of bounds"
    end
  end

  # O(1) ammortized
  def unshift(val)

    resize! if @length == @capacity

    @store[@start_idx - 1] = val
    @start_idx -= 1
    @length += 1
    self
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
  end

  def resize!
    p "resize!"
    old_store = @store
    @capacity = @capacity * 2
    @store = StaticArray.new(@capacity)
    for i in 0..@capacity-1
      @store[i] = old_store[i+@start_idx]
    end
    @start_idx = 0
  end
end
