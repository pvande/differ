module Differ
  class Diff
    def initialize
      @raw = []
    end

    def same(*str)
      return if str.empty?
      if @raw.last.is_a? String
        @raw.last << sep
      else
        @raw << (@raw.empty? ? '' : sep)
      end
      @raw.last << str.join(sep)
    end

    def delete(*str)
      return if str.empty?
      if @raw.last.is_a? Change
        @raw.last.delete << sep if @raw.last.delete?
      else
        (@raw.last || '') << sep
        @raw << (Change.new)
      end
      @raw.last.delete << str.join(sep)
    end

    def insert(*str)
      return if str.empty?
      if @raw.last.is_a? Change
        @raw.last.insert << sep if @raw.last.insert?
      else
        (@raw.last || '') << sep
        @raw << (Change.new)
      end
      @raw.last.insert << str.join(sep)
    end

    def ==(other)
      @raw == other.raw_array
    end

    def to_s
      @raw.to_s
    end

  protected
    def raw_array
      @raw
    end

  private
    def sep
      "#{$;}"
    end
  end
end