module Differ
  class Diff
    def initialize
      @raw = []
    end

    def same(*str)
      return if str.empty?
      if @raw.last.is_a? String
        @raw.last << sep
      elsif @raw.last.is_a? Change
        if @raw.last.change?
          @raw << sep
        else
          change = @raw.pop
          if change.insert? && @raw.last
            @raw.last << sep if change.insert.sub!(/^#{Regexp.quote(sep)}/, '')
          end
          if change.delete? && @raw.last
            @raw.last << sep if change.delete.sub!(/^#{Regexp.quote(sep)}/, '')
          end
          @raw << change

          @raw.last.insert << sep if @raw.last.insert?
          @raw.last.delete << sep if @raw.last.delete?
          @raw << ''
        end
      else
        @raw << ''
      end
      @raw.last << str.join(sep)
    end

    def delete(*str)
      return if str.empty?
      if @raw.last.is_a? Change
        change = @raw.pop
        if change.insert? && @raw.last
          @raw.last << sep if change.insert.sub!(/^#{Regexp.quote(sep)}/, '')
        end
        change.delete << sep if change.delete?
      else
        change = Change.new(:delete => @raw.empty? ? '' : sep)
      end

      @raw << change
      @raw.last.delete << str.join(sep)
    end

    def insert(*str)
      return if str.empty?
      if @raw.last.is_a? Change
        change = @raw.pop
        if change.delete? && @raw.last
          @raw.last << sep if change.delete.sub!(/^#{Regexp.quote(sep)}/, '')
        end
        change.insert << sep if change.insert?
      else
        change = Change.new(:insert => @raw.empty? ? '' : sep)
      end

      @raw << change
      @raw.last.insert << str.join(sep)
    end

    def ==(other)
      @raw == other.raw_array
    end

    def to_s
      @raw.join()
    end

    def format_as(f)
      f = Differ.format_for(f)
      @raw.inject('') do |sum, part|
        part = case part
        when String then part
        when Change then f.format(part)
        end
        sum << part
      end
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
