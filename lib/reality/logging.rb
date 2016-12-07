#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'logger'

module Reality
  module Logging
    class << self
      # Set the levels on an array of loggers.
      # The levels parameter must be an array matching the number of loggers supplied or a single level.
      # If a block is supplied then the levels are set to the specified values for the duration of the
      # block and then reset to original values after the block completes.
      def set_levels(levels, *loggers)
        if levels.is_a?(Array) && levels.size != loggers.size
          raise "Attempting to set log levels using an array of size #{levels.size} that does not match the number of loggers supplied #{loggers.size}"
        end

        if block_given?
          saved_levels = []
          loggers.each_with_index do |logger, index|
            saved_levels[index] = logger.level
          end
          begin
            loggers.each_with_index do |logger, index|
              logger.level = levels.is_a?(Array) ? levels[index] : levels
            end
            yield
          ensure
            loggers.each_with_index do |logger, index|
              logger.level = saved_levels[index]
            end
          end
        else
          loggers.each_with_index do |logger, index|
            logger.level = levels.is_a?(Array) ? levels[index] : levels
          end
        end
      end

      # noinspection RubyDynamicConstAssignment
      def configure(module_type, level = ::Logger::INFO, stream = STDOUT)
        logger = ::Logger.new(stream)
        logger.level = level
        logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }

        module_type.const_set(:Logger, logger)
        module_type.instance_eval do
          def self.debug(message)
            self.const_get(:Logger).debug(message)
          end

          def self.info(message)
            self.const_get(:Logger).info(message)
          end

          def self.warn(message)
            self.const_get(:Logger).warn(message)
          end

          def self.error(message)
            self.const_get(:Logger).error(message)
            raise message
          end
        end
      end
    end
  end
end
