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
end
