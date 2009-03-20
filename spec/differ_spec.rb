require 'spec_helper'

describe Differ do
  describe '#format' do
    before(:each) { Differ.format = nil }

    it 'should return the last value it was set to' do
      Differ.format = Differ::Format::HTML
      Differ.format.should == Differ::Format::HTML
    end

    it 'should default to Differ::Format::Ascii' do
      Differ.format.should == Differ::Format::Ascii
    end
  end

  describe '#format=' do
    it 'should call #format_for with the passed argument' do
      Differ.should_receive(:format_for).with(:format).once
      Differ.format = :format
    end

    it 'should raise an error on undefined behavior' do
      lambda {
        Differ.format = 'threeve'
      }.should raise_error('Unknown format type "threeve"')
    end
  end

  describe '#format_for' do
    before(:each) { Differ.format = nil }

    it 'should store any module passed to it' do
      formatter = Module.new
      Differ.format_for(formatter).should == formatter
    end

    it 'should permit nil (default behavior)' do
      Differ.format_for(nil).should == nil
    end

    it 'should raise an error on undefined behavior' do
      lambda {
        Differ.format_for('threeve')
      }.should raise_error('Unknown format type "threeve"')
    end

    describe 'when passed a symbol' do
      it 'should translate the symbol :ascii into Differ::Format::Ascii' do
        Differ.format_for(:ascii).should == Differ::Format::Ascii
      end

      it 'should translate the symbol :color into Differ::Format::Color' do
        Differ.format_for(:color).should == Differ::Format::Color
      end

      it 'should translate the symbol :html into Differ::Format::HTML' do
        Differ.format_for(:html).should == Differ::Format::HTML
      end
    end
  end

  describe '#diff_by_char' do
    def diff_by_char
      Differ.send(:diff_by_char, @to, @from)
    end

    before(:each) do
      @to = @from = 'self'
    end

    it 'should hande no-change situations' do
      @expected = diff('self')
      diff_by_char.should == @expected
    end

    it 'should handle prepends' do
      @to = "myself"
      @expected = diff(+'my', 'self')
      diff_by_char.should == @expected
    end

    it 'should handle appends' do
      @to = 'self-interest'
      @expected = diff('self', +'-interest')
      diff_by_char.should == @expected
    end

    it 'should handle leading deletes' do
      @to = 'elf'
      @expected = diff(-'s', 'elf')
      diff_by_char.should == @expected
    end

    it 'should handle trailing deletes' do
      @to = 'sel'
      @expected = diff('sel', -'f')
      diff_by_char.should == @expected
    end

    it 'should handle simultaneous leading changes' do
      @to = 'wood-elf'
      @expected = diff(('s' >> 'wood-'), 'elf')
      diff_by_char.should == @expected
    end

    it 'should handle simultaneous trailing changes' do
      @to = "seasoning"
      @expected = diff('se', ('lf' >> 'asoning'))
      diff_by_char.should == @expected
    end

    it 'should handle full-string changes' do
      @to = 'turgid'
      @expected = diff('self' >> 'turgid')
      diff_by_char.should == @expected
    end

    it 'should handle complex string additions' do
      @to = 'my sleeplife'
      @expected = diff(+'my ', 's', +'l', 'e', +'ep', 'l', +'i', 'f', +'e')
      diff_by_char.should == @expected
    end

    it 'should handle complex string deletions' do
      @from = 'my sleeplife'
      @expected = diff(-'my ', 's', -'l', 'e', -'ep', 'l', -'i', 'f', -'e')
      diff_by_char.should == @expected
    end

    it 'should handle complex string changes' do
      @from = 'my sleeplife'
      @to = 'seasonal'
      @expected = diff(-'my ', 's', -'l', 'e', ('ep' >> 'asona'), 'l', -'ife')
      diff_by_char.should == @expected
    end
  end

  describe '#diff_by_word' do
    def diff_by_word
      Differ.send(:diff_by_word, @to, @from)
    end

    before(:each) do
      @to = @from = 'the daylight will come'
    end

    it 'should hande no-change situations' do
      @expected = diff('the daylight will come')
      diff_by_word.should == @expected
    end

    it 'should handle prepends' do
      @to = "surely the daylight will come"
      @expected = diff(+'surely ', 'the daylight will come')
      diff_by_word.should == @expected
    end

    it 'should handle appends' do
      @to = 'the daylight will come in the morning'
      @expected = diff('the daylight will come', +' in the morning')
      diff_by_word.should == @expected
    end

    it 'should handle leading deletes' do
      @to = 'daylight will come'
      @expected = diff(-'the ', 'daylight will come')
      diff_by_word.should == @expected
    end

    it 'should handle trailing deletes' do
      @to = 'the daylight'
      @expected = diff('the daylight', -' will come')
      diff_by_word.should == @expected
    end

    it 'should handle simultaneous leading changes' do
      @to = 'some daylight will come'
      @expected = diff(('the' >> 'some'), ' daylight will come')
      diff_by_word.should == @expected
    end

    it 'should handle simultaneous trailing changes' do
      @to = "the daylight will flood the room"
      @expected = diff('the daylight will ', ('come' >> 'flood the room'))
      diff_by_word.should == @expected
    end

    it 'should handle full-string changes' do
      @to = 'if we should expect it'
      @expected = diff(
        ('the' >> 'if'),
        ' ',
        ('daylight' >> 'we'),
        ' ',
        ('will' >> 'should'),
        ' ',
        ('come' >> 'expect it')
      )
      diff_by_word.should == @expected
    end

    it 'should handle complex string additions' do
      @to = 'the fresh daylight will surely come'
      @expected = diff('the ', +'fresh ', 'daylight will ', +'surely ', 'come')
      diff_by_word.should == @expected
    end

    it 'should handle complex string deletions' do
      @from = 'the fresh daylight will surely come'
      @expected = diff('the ', -'fresh ', 'daylight will ', -'surely ', 'come')
      diff_by_word.should == @expected
    end

    it 'should handle complex string changes' do
      @from = 'the fresh daylight will surely come'
      @to = 'something fresh will become surly'
      @expected = diff(
        ('the' >> 'something'),
        ' fresh ',
        -'daylight ',
        'will ',
        ( 'surely' >> 'become'),
        ' ',
        ( 'come' >> 'surly' )
      )
      diff_by_word.should == @expected
    end
  end

  describe '#diff_by_line' do
    def diff_by_line
      Differ.send(:diff_by_line, @to, @from)
    end

    before(:each) do
      @to = @from = <<-HAIKU.gsub(/  +|\n\Z/, '')
        stallion sinks gently
        slowly, sleeplessly
        following harp flails
      HAIKU
    end

    it 'should hande no-change situations' do
      @expected = diff(@to)
      diff_by_line.should == @expected
    end

    it 'should handle prepends' do
      @to = <<-HAIKU.gsub(/  +|\n\Z/, '')
        A Haiku:
        stallion sinks gently
        slowly, sleeplessly
        following harp flails
      HAIKU
      @expected = diff(+"A Haiku:\n", @from)
      diff_by_line.should == @expected
    end

    it 'should handle appends' do
      @to = <<-HAIKU.gsub(/  +|\n\Z/, '')
        stallion sinks gently
        slowly, sleeplessly
        following harp flails
        -- http://everypoet.net
      HAIKU
      @expected = diff(@from, +"\n-- http://everypoet.net")
      diff_by_line.should == @expected
    end

    it 'should handle leading deletes' do
      @from = <<-HAIKU.gsub(/  +|\n\Z/, '')
        A Haiku:
        stallion sinks gently
        slowly, sleeplessly
        following harp flails
      HAIKU
      @expected = diff(-"A Haiku:\n", @to)
      diff_by_line.should == @expected
    end

    it 'should handle trailing deletes' do
      @from = <<-HAIKU.gsub(/  +|\n\Z/, '')
        stallion sinks gently
        slowly, sleeplessly
        following harp flails
        -- http://everypoet.net
      HAIKU
      @expected = diff(@to, -"\n-- http://everypoet.net")
      diff_by_line.should == @expected
    end

    it 'should handle simultaneous leading changes' do
      @to = <<-HAIKU.gsub(/  +|\n\Z/, '')
        stallion sings gently
        slowly, sleeplessly
        following harp flails
      HAIKU
      @expected = diff(
        ('stallion sinks gently' >> 'stallion sings gently'),
        "\nslowly, sleeplessly" <<
        "\nfollowing harp flails"
      )
      diff_by_line.should == @expected
    end

    it 'should handle simultaneous trailing changes' do
      @to = <<-HAIKU.gsub(/  +|\n\Z/, '')
        stallion sinks gently
        slowly, sleeplessly
        drifting ever on
      HAIKU
      @expected = diff(
        "stallion sinks gently\n" <<
        "slowly, sleeplessly\n",
        ('following harp flails' >> 'drifting ever on')
      )
      diff_by_line.should == @expected
    end

    it 'should handle full-string changes' do
      @to = <<-HAIKU.gsub(/  +|\n\Z/, '')
        glumly inert coals
        slumber lazily, shoulda
        used more Burma Shave
      HAIKU
      @expected = diff(@from >> @to)
      diff_by_line.should == @expected
    end

    it 'should handle complex string additions' do
      @to = <<-HAIKU.gsub(/  +|\n\Z/, '')
        A Haiku, with annotation:
        stallion sinks gently
        slowly, sleeplessly
        (flailing)
        following harp flails
        -- modified from source
      HAIKU
      @expected = diff(
        +"A Haiku, with annotation:\n",
        "stallion sinks gently\n" <<
        "slowly, sleeplessly\n",
        +"(flailing)\n",
        'following harp flails',
        +"\n-- modified from source"
      )
      diff_by_line.should == @expected
    end

    it 'should handle complex string deletions' do
      @from = <<-HAIKU.gsub(/  +|\n\Z/, '')
        A Haiku, with annotation:
        stallion sinks gently
        slowly, sleeplessly
        (flailing)
        following harp flails
        -- modified from source
      HAIKU
      @expected = diff(
        -"A Haiku, with annotation:\n",
        "stallion sinks gently\n" <<
        "slowly, sleeplessly\n",
        -"(flailing)\n",
        'following harp flails',
        -"\n-- modified from source"
      )
      diff_by_line.should == @expected
    end

    it 'should handle complex string changes' do
      @to = <<-HAIKU.gsub(/  +|\n\Z/, '')
        stallion sings gently
        slowly, sleeplessly
        (flailing)
        following harp flails
        -- modified from source
      HAIKU
      @expected = diff(
        ('stallion sinks gently' >> 'stallion sings gently'),
        "\nslowly, sleeplessly\n",
        +"(flailing)\n",
        'following harp flails',
        +"\n-- modified from source"
      )
      diff_by_line.should == @expected
    end
  end

  describe '#diff (with arbitrary boundary)' do
    def diff_by_comma
      Differ.send(:diff, @to, @from, ', ')
    end

    before(:each) do
      @to = @from = 'alteration, asymmetry, a deviation'
    end

    it 'should hande no-change situations' do
      @expected = diff('alteration, asymmetry, a deviation')
      diff_by_comma.should == @expected
    end

    it 'should handle prepends' do
      @to = "aberration, alteration, asymmetry, a deviation"
      @expected = diff(+'aberration, ', 'alteration, asymmetry, a deviation')
      diff_by_comma.should == @expected
    end

    it 'should handle appends' do
      @to = "alteration, asymmetry, a deviation, change"
      @expected = diff('alteration, asymmetry, a deviation', +', change')
      diff_by_comma.should == @expected
    end

    it 'should handle leading deletes' do
      @to = 'asymmetry, a deviation'
      @expected = diff(-'alteration, ', 'asymmetry, a deviation')
      diff_by_comma.should == @expected
    end

    it 'should handle trailing deletes' do
      @to = 'alteration, asymmetry'
      @expected = diff('alteration, asymmetry', -', a deviation')
      diff_by_comma.should == @expected
    end

    it 'should handle simultaneous leading changes' do
      @to = 'aberration, asymmetry, a deviation'
      @expected = diff(('alteration' >> 'aberration'), ', asymmetry, a deviation')
      diff_by_comma.should == @expected
    end

    it 'should handle simultaneous trailing changes' do
      @to = 'alteration, asymmetry, change'
      @expected = diff('alteration, asymmetry, ', ('a deviation' >> 'change'))
      diff_by_comma.should == @expected
    end

    it 'should handle full-string changes' do
      @to = 'uniformity, unison, unity'
      @expected = diff(@from >> @to)
      diff_by_comma.should == @expected
    end

    it 'should handle complex string additions' do
      @to = 'aberration, alteration, anomaly, asymmetry, a deviation, change'
      @expected = diff(
        +'aberration, ',
        'alteration, ',
        +'anomaly, ',
        'asymmetry, a deviation',
        +', change'
      )
      diff_by_comma.should == @expected
    end

    it 'should handle complex string deletions' do
      @from = 'aberration, alteration, anomaly, asymmetry, a deviation, change'
      @expected = diff(
        -'aberration, ',
        'alteration, ',
        -'anomaly, ',
        'asymmetry, a deviation',
        -', change'
      )
      diff_by_comma.should == @expected
    end

    it 'should handle complex string changes' do
      @from = 'a, d, g, gh, x'
      @to = 'a, b, c, d, e, f, g, h, i, j'
      @expected = diff(
        'a, ',
        +'b, c, ',
        'd, ',
        +'e, f, ',
        'g, ',
        ('gh, x' >> 'h, i, j')
      )
      diff_by_comma.should == @expected
    end
  end

  describe '#diff (with implied boundary)' do
    def diff_by_line
      Differ.send(:diff, @to, @from)
    end

    before(:each) do
      @to = @from = <<-HAIKU.gsub(/  +|\n\Z/, '')
        stallion sinks gently
        slowly, sleeplessly
        following harp flails
      HAIKU
    end

    it 'should do diffs by line' do
      @to = <<-HAIKU.gsub(/  +|\n\Z/, '')
        stallion sinks gently
        slowly, restlessly
        following harp flails
      HAIKU
      @expected = diff(
        "stallion sinks gently\n",
        ('slowly, sleeplessly' >> 'slowly, restlessly'),
        "\nfollowing harp flails"
      )
      diff_by_line.should == @expected
    end
  end
end
