module MrubyRedmineActivity
  class Help
    USAGE_COMMON = <<-EOS
Usage:
  mruby-redmine_activity -v, --version   # Print the version
  mruby-redmine_activity get             # Print one day's activities
  mruby-redmine_activity help [COMMAND]  # Describe available commands or one specific command
  mruby-redmine_activity today           # Print today's activities
    EOS

    USAGE_GET = <<-EOS

Usage:
  mruby-redmine_activity get

Options:
  [--url=URL]
  [--login-id=LOGIN_ID]
  [--password=PASSWORD]
  [--date=DATE]

Print one day's activities
    EOS

    USAGE_TODAY = <<-EOS
Usage:
  mruby-redmine_activity today

Options:
  [--url=URL]
  [--login-id=LOGIN_ID]
  [--password=PASSWORD]

Print today's activities
    EOS

    def initialize(command = nil)
      @command = command
    end

    def run
      puts case @command
           when 'get'   then USAGE_GET
           when 'today' then USAGE_TODAY
           else              USAGE_COMMON
           end
    end
  end
end
