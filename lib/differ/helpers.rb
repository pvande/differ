module Differ
  module Helpers
    def same(*str)
      last = @results.last
      (last.is_a?(String) ? last : @results) << str.join
    end

    def delete(*str)
      last = @results.last
      @results.push(last = Change.new) unless last.is_a?(Change)
      last.del << str.join
    end

    def insert(*str)
      last = @results.last
      @results.push(last = Change.new) unless last.is_a?(Change)
      last.add << str.join
    end
  end
end