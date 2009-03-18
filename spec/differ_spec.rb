require 'spec_helper'

describe Differ do
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
end
