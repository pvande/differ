module Differ
  module Format
    module Color
      class << self
        def format(change)
          (change.change? && as_change(change)) ||
          (change.delete? && as_delete(change)) ||
          (change.insert? && as_insert(change)) ||
          ''
        end

      private
        def as_insert(change)
          "\033[32m#{change.insert}\033[0m"
        end

        def as_delete(change)
          "\033[31m#{change.delete}\033[0m"
        end

        def as_change(change)
          as_delete(change) << as_insert(change)
        end
      end
    end
  end
end