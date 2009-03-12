module Differ
  module Helpers
    def same(*str)
      return if str.empty?
      last = @results.last
      (last.is_a?(String) ? last : @results) << str.join
    end

    def delete(*str)
      return if str.empty?
      last = @results.last
      @results.push(last = Change.new) unless last.is_a?(Change)
      last.delete << str.join
    end

    def insert(*str)
      return if str.empty?
      last = @results.last
      @results.push(last = Change.new) unless last.is_a?(Change)
      last.insert << str.join
    end
  end
end