require 'spec_helper'

describe Differ::Helpers do
  include Differ::Helpers

  before(:each) do
    @results = []
  end

  describe '#same' do
    it 'should append to the result list if empty' do
      same('c')
      @results.should == [ 'c' ]
    end

    it 'should concatenate its arguments' do
      same('a', 'b', 'c', 'd')
      @results.should == [ 'abcd' ]
    end

    it 'should append to the last result if it was a String' do
      @results << 'a'
      same('b')
      @results.should == [ 'ab' ]
    end

    it 'should append to the result list if the last result was non-String' do
      @results << 1
      same('a')
      @results.should == [ 1, 'a' ]
    end
  end

  describe '#delete' do
    it 'should append to the result list if empty' do
      delete('c')
      @results.should == [ -'c' ]
    end

    it 'should concatenate its arguments' do
      delete('a', 'b', 'c', 'd')
      @results.should == [ -'abcd' ]
    end

    it 'should append to the last result if it was a Change' do
      @results << -'a'
      delete('b')
      @results.should == [ -'ab' ]
    end

    it "should not change the 'to' portion of the last Change result" do
      @results << +'y'
      delete('x')
      @results.should == [ ('x' >> 'y') ]
    end

    it 'should append a Change if the last result was non-Change' do
      @results << 1
      delete('a')
      @results.should == [ 1, -'a' ]
    end
  end

  describe '#insert' do
    it 'should append to the result list if empty' do
      insert('c')
      @results.should == [ +'c' ]
    end

    it 'should concatenate its arguments' do
      insert('a', 'b', 'c', 'd')
      @results.should == [ +'abcd' ]
    end

    it 'should append to the last result if it was a Change' do
      @results << +'a'
      insert('b')
      @results.should == [ +'ab' ]
    end

    it "should not change the 'from' portion of the last Change result" do
      @results << -'x'
      insert('y')
      @results.should == [ ('x' >> 'y') ]
    end

    it 'should append a Change if the last result was non-Change' do
      @results << 1
      insert('a')
      @results.should == [ 1, +'a' ]
    end
  end
end
