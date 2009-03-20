require 'spec_helper'

describe Differ::Format::HTML do
  it 'should format inserts well' do
    @expected = '<ins class="differ">SAMPLE</ins>'
    Differ::Format::HTML.format(+'SAMPLE').should == @expected
  end

  it 'should format deletes well' do
    @expected = '<del class="differ">SAMPLE</del>'
    Differ::Format::HTML.format(-'SAMPLE').should == @expected
  end

  it 'should format changes well' do
    @expected = '<del class="differ">THEN</del><ins class="differ">NOW</ins>'
    Differ::Format::HTML.format('THEN' >> 'NOW').should == @expected
  end
end