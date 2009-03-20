require 'spec_helper'

describe Differ::Format::Ascii do
  it 'should format inserts well' do
    @expected = '{+"SAMPLE"}'
    Differ::Format::Ascii.format(+'SAMPLE').should == @expected
  end

  it 'should format deletes well' do
    @expected = '{-"SAMPLE"}'
    Differ::Format::Ascii.format(-'SAMPLE').should == @expected
  end

  it 'should format changes well' do
    @expected = '{"THEN" >> "NOW"}'
    Differ::Format::Ascii.format('THEN' >> 'NOW').should == @expected
  end
end