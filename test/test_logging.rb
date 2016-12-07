require File.expand_path('../helper', __FILE__)

class Reality::TestLogging < Reality::TestCase

  module MyModule
  end

  def test_basic_operation
    io = StringIO.new('', 'w')
    Reality::Logging.configure(MyModule, ::Logger::INFO, io)

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

  def test_set_levels
    logger1 = ::Logger.new(STDOUT)
    logger1.level = ::Logger::INFO
    logger2 = ::Logger.new(STDOUT)
    logger2.level = ::Logger::WARN

    loggers = [logger1, logger2]

    assert_equal ::Logger::INFO, logger1.level
    assert_equal ::Logger::WARN, logger2.level

    Reality::Logging.set_levels(::Logger::DEBUG, *loggers) do
      assert_equal ::Logger::DEBUG, logger1.level
      assert_equal ::Logger::DEBUG, logger2.level
    end

    assert_equal ::Logger::INFO, logger1.level
    assert_equal ::Logger::WARN, logger2.level

    Reality::Logging.set_levels([::Logger::DEBUG, ::Logger::INFO], *loggers) do
      assert_equal ::Logger::DEBUG, logger1.level
      assert_equal ::Logger::INFO, logger2.level
    end

    assert_equal ::Logger::INFO, logger1.level
    assert_equal ::Logger::WARN, logger2.level

    Reality::Logging.set_levels([::Logger::DEBUG, ::Logger::INFO], *loggers)
    assert_equal ::Logger::DEBUG, logger1.level
    assert_equal ::Logger::INFO, logger2.level
  end
end
