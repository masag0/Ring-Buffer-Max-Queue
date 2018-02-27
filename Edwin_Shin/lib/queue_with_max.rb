# Implement a queue with #enqueue and #dequeue, as well as a #max API,
# a method which returns the maximum element still in the queue. This
# is trivial to do by spending O(n) time upon dequeuing.
# Can you do it in O(1) amortized? Maybe use an auxiliary storage structure?

# Use your RingBuffer to achieve optimal shifts! Write any additional
# methods you need.

require_relative 'ring_buffer'

class QueueWithMax
  attr_accessor :store

  def initialize
    @store = RingBuffer.new
    @push = RingBuffer.new
    @pop = RingBuffer.new
    @max = nil
    @max2 = nil
  end

  def enqueue(val)
    @max = val if @max == nil
    @max = val if val > @max
    @push.push([val, @max])
    @store.push(val)
    @store
  end

  def dequeue
    if (@pop.length == 0)
      i = @push.length - 1
      while i >= 0
        @max2 = @push[i][0] if @max2 == nil || @push[i][0] > @max2
        @pop.push([@push[i][0], @max2])
        @push.pop
        i -= 1
      end
    end
    @pop.pop
    @store.pop
    @store


  end

  def max
    if @push.length > 0 && @pop.length == 0
      @push[@push.length - 1][1]
    elsif @pop.length > 0 && @push.length == 0
      @pop[@pop.length - 1][1]
    else
      if @push[@push.length - 1][1] > @pop[@pop.length - 1][1]
        @push[@push.length - 1][1]
      else
        @pop[@pop.length - 1][1]
      end
    end
  end

  def length
    @store.length
  end

end
