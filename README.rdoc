= Differ

    As streams of text swirled before the young man's eyes, his mind swam with
  thoughts of many things. They would have to wait, however, as he focussed his
  full concentration on the shifting patterns ahead of him. A glint of light
  reflecting off a piece of buried code caught his eye and any hope he had was
  lost. For the very moment he glanced aside, the landscape became Different.
    The young man gave a small sigh and trudged onward in solemn resignation,
  fated to wander the desolate codebanks in perpetuity.

Differ is a flexible, pure-Ruby diff library, suitable for use in both command
line scripts and web applications.  The flexibility comes from the fact that
diffs can be built at completely arbitrary levels of granularity (some common
ones are built-in), and can be output in a variety of formats.

== Installation

  sudo gem install differ

== Usage

There are a number of ways to use Differ, depending on your situation and needs.

  @original = "Epic lolcat fail!"
  @current  = "Epic wolfman fail!"

You can call the Differ module directly.

  require 'differ'

There are a number of built-in diff methods to choose from...

  @diff = Differ.diff_by_line(@current, @original)
    # => "{"Epic lolcat fail!" >> "Epic wolfman fail!"}"

  @diff = Differ.diff_by_word(@current, @original)
    # => "Epic {"lolcat" >> "wolfman"} fail!"

  @diff = Differ.diff_by_char(@current, @original)
    # => "Epic {+"wo"}l{-"olcat "}f{+"m"}a{+"n fa"}il!"

... or call #diff directly and supply your own boundary string!

  @diff = Differ.diff(@current, @original)  # implicitly by line!
    # => "{"Epic lolcat fail!" >> "Epic wolfman fail!"}"

  @diff = Differ.diff(@current, @original, 'i')
    # => "Epi{"c lolcat fa" >> "c wolfman fa"}il"

If you would like something a little more inline...

  require 'differ/string'

  @diff = @current.diff(@original)  # implicitly by line!
    # => "{"Epic lolcat fail!" >> "Epic wolfman fail!"}"

... or a lot more inline...

  @diff = (@current - @original)    # implicitly by line!
    # => "{"Epic lolcat fail!" >> "Epic wolfman fail!"}"

  $; = ' '
  @diff = (@current - @original)
    # => "Epic {"lolcat" >> "wolfman"} fail!"

... we've pretty much got you covered.

=== Output Formatting

Need a different output format?  We've got a few of those too.

  Differ.format = :ascii  # <- Default
  Differ.format = :color
  Differ.format = :html

  Differ.format = MyCustomFormatModule

Don't want to change the system-wide default for only a single diff output?
Yeah, me either.

  @diff = (@current - @original)
  @diff.format_as(:color)

== Copyright

Copyright (c) 2009 Pieter Vande Bruggen.

(The GIFT License, v1)

Permission is hereby granted to use this software and/or its source code for
whatever purpose you should choose. Seriously, go nuts. Use it for your personal
RSS feed reader, your wildly profitable social network, or your mission to Mars.

I don't care, it's yours. Change the name on it if you want -- in fact, if you
start significantly changing what it does, I'd rather you did! Make it your own
little work of art, complete with a stylish flowing signature in the corner. All
I really did was give you the canvas.  And my blessing.

  Know always right from wrong, and let others see your good works.
