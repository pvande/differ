require 'differ/helpers'
require 'differ/change'

module Differ
  class << self
    include Helpers

    def diff(target, source, separator)
      old_sep, $; = $;, separator
      @results = []

      target = target.split(separator)
      source = source.split(separator)

      advance(target, source) until source.empty? || target.empty?
      insert(*target) || delete(*source)

      $; = old_sep
      @results
    end

    def diff_by_char(to, from)
      diff(to, from, '')
    end

  private
    def advance(target, source)
      del, add = source.shift, target.shift

      prioritize_insert = target.length > source.length
      insert = target.index(del)
      delete = source.index(add)

      if del == add
        same(add)
      elsif insert && prioritize_insert
        change(:insert, target.unshift(add), insert)
      elsif delete
        change(:delete, source.unshift(del), delete)
      elsif insert && !prioritize_insert
        change(:insert, target.unshift(add), insert)
      else
        insert(add) && delete(del)
      end
    end

    def change(method, array, index)
      send(method, *array.slice!(0..index))
      same(array.shift)
    end
  end
end