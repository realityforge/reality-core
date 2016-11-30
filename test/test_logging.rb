require File.expand_path('../helper', __FILE__)

class Reality::TestLogging < Reality::TestCase

  module MyModule
  end

  def test_basic_operation
    io = StringIO.new('', 'w')
    Reality::Logging.configure(MyModule, io)

    assert_true MyModule::Logger.is_a?(::Logger)

    MyModule.debug('Debug output')

    assert_equal io.string, ''

    MyModule.info('Info output')

    assert_equal io.string, "Info output\n"

    MyModule.warn('Warn output')

    assert_equal io.string, "Info output\nWarn output\n"

    assert_raise(RuntimeError) { MyModule.error('Error output') }

    assert_equal io.string, "Info output\nWarn output\nError output\n"

    MyModule::Logger.level = ::Logger::DEBUG

    MyModule.debug('Debug output')

    assert_equal io.string, "Info output\nWarn output\nError output\nDebug output\n"
  end
end
