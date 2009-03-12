require 'spec_helper'

describe Differ do
  describe '#diff_by_char' do
    def diff
      Differ.send(:diff_by_char, @to, @from)
    end

    before(:each) do
      @to = @from = 'self'
    end

    it 'should hande no-change situations' do
      @expected = [ 'self' ]
      diff.should == @expected
    end

    it 'should handle prepends' do
      @to = "myself"
      @expected = [ +'my', 'self' ]
      diff.should == @expected
    end

    it 'should handle appends' do
      @to = 'self-interest'
      @expected = [ 'self', +'-interest' ]
      diff.should == @expected
    end

    it 'should handle leading deletes' do
      @to = 'elf'
      @expected = [ -'s', 'elf' ]
      diff.should == @expected
    end

    it 'should handle trailing deletes' do
      @to = 'sel'
      @expected = [ 'sel', -'f' ]
      diff.should == @expected
    end

    it 'should handle simultaneous leading changes' do
      @to = 'wood-elf'
      @expected = [ ('s' >> 'wood-'), 'elf' ]
      diff.should == @expected
    end

    it 'should handle simultaneous trailing changes' do
      @to = "seasoning"
      @expected = [ 'se', ('lf' >> 'asoning') ]
      diff.should == @expected
    end

    it 'should handle full-string changes' do
      @to = 'turgid'
      @expected = [ ('self' >> 'turgid') ]
      diff.should == @expected
    end

    it 'should handle complex string additions' do
      @to = 'my sleeplife'
      @expected = [ +'my ', 's', +'l', 'e', +'ep', 'l', +'i', 'f', +'e' ]
      diff.should == @expected
    end

    it 'should handle complex string deletions' do
      @from = 'my sleeplife'
      @expected = [ -'my ', 's', -'l', 'e', -'ep', 'l', -'i', 'f', -'e' ]
      diff.should == @expected
    end

    it 'should handle complex string changes' do
      @from = 'my sleeplife'
      @to = 'seasonal'
      @expected = [ -'my ', 's', -'l', 'e', ('ep' >> 'asona'), 'l', -'ife' ]
      diff.should == @expected
    end
  end

  describe '#diff_by_word' do
    def diff
      Differ.send(:diff_by_word, @to, @from)
    end

    before(:each) do
      @to = @from = 'the daylight will come'
    end

    it 'should hande no-change situations' do
      @expected = [ 'the daylight will come' ]
      diff.should == @expected
    end

    it 'should handle prepends' do
      @to = "surely the daylight will come"
      @expected = [ +'surely ', 'the daylight will come' ]
      diff.should == @expected
    end

    it 'should handle appends' do
      @to = 'the daylight will come in the morning'
      @expected = [ 'the daylight will come', +' in the morning' ]
      diff.should == @expected
    end

    it 'should handle leading deletes' do
      @to = 'daylight will come'
      @expected = [ -'the ', 'daylight will come' ]
      diff.should == @expected
    end

    it 'should handle trailing deletes' do
      @to = 'the daylight'
      @expected = [ 'the daylight', -' will come' ]
      diff.should == @expected
    end

    it 'should handle simultaneous leading changes' do
      @to = 'some daylight will come'
      @expected = [ ('the' >> 'some'), ' daylight will come' ]
      diff.should == @expected
    end

    it 'should handle simultaneous trailing changes' do
      @to = "the daylight will flood the room"
      @expected = [ 'the daylight will ', ('come' >> 'flood the room') ]
      diff.should == @expected
    end

    it 'should handle full-string changes' do
      @to = 'if we should expect it'
      @expected = [
        ('the' >> 'if'),
        ' ',
        ('daylight' >> 'we'),
        ' ',
        ('will' >> 'should'),
        ' ',
        ('come' >> 'expect it')
      ]
      diff.should == @expected
    end

    it 'should handle complex string additions' do
      @to = 'the fresh daylight will surely come'
      @expected = [ 'the ', +'fresh ', 'daylight will ', +'surely ', 'come' ]
      diff.should == @expected
    end

    it 'should handle complex string deletions' do
      @from = 'the fresh daylight will surely come'
      @expected = [ 'the ', -'fresh ', 'daylight will ', -'surely ', 'come' ]
      diff.should == @expected
    end

    it 'should handle complex string changes' do
      @from = 'the fresh daylight will surely come'
      @to = 'something fresh will become surly'
      @expected = [
        ('the' >> 'something'),
        ' fresh ',
        -'daylight ',
        'will ',
        ( 'surely' >> 'become'),
        ' ',
        ( 'come' >> 'surly' )
      ]
      diff.should == @expected
    end
  end
end
