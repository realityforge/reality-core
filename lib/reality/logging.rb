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
      # noinspection RubyDynamicConstAssignment
      def configure(module_type, stream = STDOUT)
        logger = ::Logger.new(stream)
        logger.level = ::Logger::INFO
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
