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

    def to_s
      Differ.format.format(self)
    end
    alias :inspect :to_s

    def ==(other)
      self.insert == other.insert && self.delete == other.delete
    end
  end
end