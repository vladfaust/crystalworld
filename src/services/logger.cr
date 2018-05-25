require "logger"
require "colorize"

# A custom singleton colored logger.
#
# ```
# Services::Logger.initialize(Logger::DEBUG)
# D, [15:45] DEBUG > hello world
# ```
class Services::Logger
  class_getter! instance : ::Logger?

  def self.init(level : ::Logger::Severity = ::Logger::INFO)
    @@instance = ::Logger.new(STDOUT).tap do |l|
      l.level = level
      l.formatter = ::Logger::Formatter.new do |severity, datetime, progname, message, io|
        label = severity.unknown? ? "ANY" : severity.to_s

        fore, back = case severity
                     when ::Logger::DEBUG then {:dark_gray, nil}
                     when ::Logger::INFO  then {:green, nil}
                     when ::Logger::WARN  then {:yellow, nil}
                     when ::Logger::ERROR then {nil, :red}
                     when ::Logger::FATAL then {nil, :red}
                     else                      {nil, nil}
                     end

        prefix = ("[" + datetime.to_s("%X:%L") + "] " + label.rjust(5) + " > ").colorize
        prefix.fore(fore) if fore
        prefix.back(back) if back

        io << prefix << message
      end
    end
  end
end

# A globally accessible custom logger instance (essentialy a shortcut).
def logger
  Services::Logger.instance
end
