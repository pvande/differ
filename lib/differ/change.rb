module Differ
  class Change # :nodoc:
    attr_accessor :insert, :delete
    def initialize(options = {})
      @insert = options[:insert] || ''
      @delete = options[:delete] || ''
    end

    def insert?
      !@insert.empty?
    end

    def delete?
      !@delete.empty?
    end

    def change?
      !@insert.empty? && !@delete.empty?
    end

    def as_insert ; "+#{@insert.inspect}" ; end
    def as_delete ; "-#{@delete.inspect}" ; end
    def as_change ; "{#{@delete.inspect} >> #{@insert.inspect}}" ; end

    def to_s
      (change? && self.as_change) ||
      (insert? && self.as_insert) ||
      (delete? && self.as_delete) ||
      ''
    end
    alias :inspect :to_s

    def ==(other)
      self.insert == other.insert && self.delete == other.delete
    end
  end
end