require File.expand_path('../helper', __FILE__)

class Reality::TestOptions < Reality::TestCase

  module MyModule
  end

  def test_basic_operation

    Reality::Options.check({}, [:a, :b, :c])

    assert_raise(ArgumentError.new("Unknown option ':z' passed to method")) { Reality::Options.check({:a => 1, :z => 'x'}, [:a, :b, :c]) }
    assert_raise(ArgumentError.new('Unknown options [:x, :z] passed to method')) { Reality::Options.check({:x => 1, :z => 'x'}, [:a, :b, :c]) }
    assert_raise(ArgumentError.new('Unknown options [:x, :z] passed to initializer')) { Reality::Options.check({:x => 1, :z => 'x'}, [:a, :b, :c], nil, 'initializer') }

    io = StringIO.new('', 'w')
    Reality::Logging.configure(MyModule, ::Logger::INFO, io)

    assert_raise(RuntimeError.new('Unknown options [:x, :z] passed to initializer')) { Reality::Options.check({:x => 1, :z => 'x'}, [:a, :b, :c], MyModule, 'initializer') }

    assert_equal "Unknown options [:x, :z] passed to initializer\n", io.string
  end
end
