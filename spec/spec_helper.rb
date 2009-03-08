require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'differ'

Spec::Runner.configure do |config|

end

class String
  def +@
    Differ::Change.new(:add => self)
  end

  def -@
    Differ::Change.new(:del => self)
  end

  def >>(to)
    Differ::Change.new(:del => self, :add => to)
  end
end
