require 'spec_helper'

describe Differ::Diff do
  before(:each) do
    $; = nil
    @diff = Differ::Diff.new
  end

  describe '#to_s' do
    it 'should concatenate the result list' do
      diff('a', 'b', 'c').to_s.should == 'abc'
    end

    it 'should concatenate without regard for the $;' do
      $; = '*'
      diff('a', 'b', 'c').to_s.should == 'abc'
    end

    it 'should delegate insertion changes to the Change class' do
      i = +'b'
      i.should_receive(:as_insert).once.and_return('!')
      diff('a', i, 'c').to_s.should == 'a!c'
    end

    it 'should delegate deletion changes to the Change class' do
      d = -'b'
      d.should_receive(:as_delete).once.and_return('!')
      diff('a', d, 'c').to_s.should == 'a!c'
    end

    it 'should delegate replacement changes to the Change class' do
      r = ('b' >> 'd')
      r.should_receive(:as_change).once.and_return('!')
      diff('a', r, 'c').to_s.should == 'a!c'
    end
  end

  describe '#same' do
    it 'should append to the result list' do
      @diff.same('c')
      @diff.should == diff('c')
    end

    it 'should concatenate its arguments' do
      @diff.same('a', 'b', 'c', 'd')
      @diff.should == diff('abcd')
    end

    it 'should join its arguments with $;' do
      $; = '*'
      @diff.same(*'a*b*c*d'.split)
      @diff.should == diff('a*b*c*d')
    end

    describe 'when the last result was a String' do
      before(:each) do
        @diff = diff('a')
      end

      it 'should append to the last result' do
        @diff.same('b')
        @diff.should == diff('ab')
      end

      it 'should join to the last result with $;' do
        $; = '*'
        @diff.same('b')
        @diff.should == diff('a*b')
      end
    end

    describe 'when the last result was not a String' do
      before(:each) do
        @diff = diff(1)
      end

      it 'should append to the result list' do
        @diff.same('a')
        @diff.should == diff(1, 'a')
      end

      it 'should prepend the result with $;' do
        $; = '*'
        @diff.same('a')
        @diff.should == diff(1, '*a')
      end
    end
  end

  describe '#delete' do
    it 'should append to the result list' do
      @diff.delete('c')
      @diff.should == diff(-'c')
    end

    it 'should concatenate its arguments' do
      @diff.delete('a', 'b', 'c', 'd')
      @diff.should == diff(-'abcd')
    end

    it 'should join its arguments with $;' do
      $; = '*'
      @diff.delete(*'a*b*c*d'.split)
      @diff.should == diff(-'a*b*c*d')
    end

    describe 'when the last result was a Change' do
      describe '(delete)' do
        before(:each) do
          @diff = diff(-'a')
        end

        it 'should append to the last result' do
          @diff.delete('b')
          @diff.should == diff(-'ab')
        end

        it 'should join to the last result with $;' do
          $; = '*'
          @diff.delete('b')
          @diff.should == diff(-'a*b')
        end
      end

      describe '(insert)' do
        before(:each) do
          @diff = diff(+'a')
        end

        it "should not change the 'insert' portion of the last result" do
          @diff.delete('b')
          @diff.should == diff('b' >> 'a')
        end
      end
    end

    describe 'when the last result was not a Change' do
      before(:each) do
        @diff = diff('a')
      end

      it 'should append a Change to the result list' do
        @diff.delete('b')
        @diff.should == diff('a', -'b')
      end

      it 'should append $; to the previous result' do
        $; = '*'
        @diff.delete('b')
        @diff.should == diff('a*', -'b')
      end
    end
  end

  describe '#insert' do
    it 'should append to the result list' do
      @diff.insert('c')
      @diff.should == diff(+'c')
    end

    it 'should concatenate its arguments' do
      @diff.insert('a', 'b', 'c', 'd')
      @diff.should == diff(+'abcd')
    end

    it 'should join its arguments with $;' do
      $; = '*'
      @diff.insert(*'a*b*c*d'.split)
      @diff.should == diff(+'a*b*c*d')
    end

    describe 'when the last result was a Change' do
      describe '(delete)' do
        before(:each) do
          @diff = diff(-'b')
        end

        it "should not change the 'insert' portion of the last result" do
          @diff.insert('a')
          @diff.should == diff('b' >> 'a')
        end
      end

      describe '(insert)' do
        before(:each) do
          @diff = diff(+'a')
        end

        it 'should append to the last result' do
          @diff.insert('b')
          @diff.should == diff(+'ab')
        end

        it 'should join to the last result with $;' do
          $; = '*'
          @diff.insert('b')
          @diff.should == diff(+'a*b')
        end
      end
    end

    describe 'when the last result was not a Change' do
      before(:each) do
        @diff = diff('a')
      end

      it 'should append a Change to the result list' do
        @diff.insert('b')
        @diff.should == diff('a', +'b')
      end

      it 'should append $; to the previous result' do
        $; = '*'
        @diff.insert('b')
        @diff.should == diff('a*', +'b')
      end
    end
  end
end