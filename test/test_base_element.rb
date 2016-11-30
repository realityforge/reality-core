require File.expand_path('../helper', __FILE__)

class Reality::TestBaseElement < Reality::TestCase

  class TestElement < Reality::BaseElement
    attr_accessor :a
    attr_accessor :b
    attr_accessor :c

  end

  def test_basic_operation
    element1 = TestElement.new do |e|
      e.a = 1
      e.b = 2
      e.c = 3
    end
    assert_equal 1, element1.a
    assert_equal 2, element1.b
    assert_equal 3, element1.c

    element2 = TestElement.new(:a => '1', :b => '2', 'c' => '3') do |e|
      e.a = 1
    end
    assert_equal 1, element2.a
    assert_equal '2', element2.b
    assert_equal '3', element2.c

    assert_raise(NoMethodError) do
      TestElement.new(:x => '1')
    end
  end
end
