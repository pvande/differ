require 'ostruct'
require 'differ/helpers'

module Differ
  class Change < OpenStruct
    def initialize(options = {})
      super({ :add => '', :del => '' }.merge(options))
    end

    def inspect
      if !add.empty? && !del.empty?
        "{#{del.inspect} >> #{add.inspect}}"
      elsif !add.empty?
        "+#{add.inspect}"
      elsif !del.empty?
        "-#{del.inspect}"
      end
    end
  end

  class << self
    include Helpers

  private
    def change(method, array, index)
      send(method, *array.slice!(0..index))
      same(array.shift)
    end

    def diff_by_char(to, from)
      @results = []
      a = { :from => from.split(''), :to => to.split('') }

      until a[:from].empty? || a[:to].empty?
        from, to = a.values_at(:from, :to).collect { |el| el.shift }
        same(to) && next if from == to

        prioritize_insert = a[:to].length > a[:from].length
        if (insert_index = a[:to].index(from)) && prioritize_insert
          change(:insert, a[:to].unshift(to), insert_index)
        elsif (delete_index = a[:from].index(to))
          change(:delete, a[:from].unshift(from), delete_index)
        elsif insert_index
          change(:insert, a[:to].unshift(to), insert_index)
        else
          insert(to) && delete(from)
        end
      end

      insert(*a[:to])   unless a[:to].empty?
      delete(*a[:from]) unless a[:from].empty?

      @results
    end
  end
end