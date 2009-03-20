require 'differ/change'
require 'differ/diff'

module Differ
  class << self

    def diff(target, source, separator = "\n")
      old_sep, $; = $;, separator

      target = target.split(separator)
      source = source.split(separator)

      $; = '' if separator.is_a? Regexp

      @diff = Diff.new
      advance(target, source) until source.empty? || target.empty?
      @diff.insert(*target) || @diff.delete(*source)
      return @diff
    ensure
      $; = old_sep
    end

    def diff_by_char(to, from)
      diff(to, from, '')
    end

    def diff_by_word(to, from)
      diff(to, from, /\b/)
    end

    def diff_by_line(to, from)
      diff(to, from, "\n")
    end

  private
    def advance(target, source)
      del, add = source.shift, target.shift

      prioritize_insert = target.length > source.length
      insert = target.index(del)
      delete = source.index(add)

      if del == add
        @diff.same(add)
      elsif insert && prioritize_insert
        change(:insert, target.unshift(add), insert)
      elsif delete
        change(:delete, source.unshift(del), delete)
      elsif insert && !prioritize_insert
        change(:insert, target.unshift(add), insert)
      else
        @diff.insert(add) && @diff.delete(del)
      end
    end

    def change(method, array, index)
      @diff.send(method, *array.slice!(0..index))
      @diff.same(array.shift)
    end
  end
end