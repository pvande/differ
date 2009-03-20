module Differ
  module Format
    module Ascii
      class << self
        def format(change)
          (change.change? && as_change(change)) ||
          (change.delete? && as_delete(change)) ||
          (change.insert? && as_insert(change)) ||
          ''
        end

      private
        def as_insert(change)
          "{+#{change.insert.inspect}}"
        end

        def as_delete(change)
          "{-#{change.delete.inspect}}"
        end

        def as_change(change)
          "{#{change.delete.inspect} >> #{change.insert.inspect}}"
        end
      end
    end
  end
end