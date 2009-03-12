require 'spec_helper'

describe Differ::Change do
  describe '(empty)' do
    before(:each) do
      @change = Differ::Change.new()
    end

    it 'should have a default insert' do
      @change.insert.should == ''
    end

    it 'should have a default delete' do
      @change.delete.should == ''
    end

    it 'should stringify to ""' do
      @change.to_s.should == ''
    end
  end

  describe '(insert only)' do
    before(:each) do
      @change = Differ::Change.new(:insert => 'foo')
    end

    it 'should populate the :insert parameter' do
      @change.insert.should == 'foo'
    end

    it 'should have a default delete' do
      @change.delete.should == ''
    end

    it 'should stringify via the #as_insert method' do
      @change.should_receive(:as_insert).once.and_return('FORMAT')
      @change.to_s.should == 'FORMAT'
    end

    it { (@change).should be_an_insert }
  end

  describe '(delete only)' do
    before(:each) do
      @change = Differ::Change.new(:delete => 'bar')
    end

    it 'should have a default :insert' do
      @change.insert.should == ''
    end

    it 'should populate the :delete parameter' do
      @change.delete.should == 'bar'
    end

    it 'should stringify via the #as_delete method' do
      @change.should_receive(:as_delete).once.and_return('FORMAT')
      @change.to_s.should == 'FORMAT'
    end

    it { (@change).should be_a_delete }
  end

  describe '(both insert and delete)' do
    before(:each) do
      @change = Differ::Change.new(:insert => 'foo', :delete => 'bar')
    end

    it 'should populate the :insert parameter' do
      @change.insert.should == 'foo'
    end

    it 'should populate the :delete parameter' do
      @change.delete.should == 'bar'
    end

    it 'should stringify via the #as_change method' do
      @change.should_receive(:as_change).once.and_return('FORMAT')
      @change.to_s.should == 'FORMAT'
    end

    it { (@change).should be_a_change }
  end
end