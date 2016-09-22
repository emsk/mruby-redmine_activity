module MrubyRedmineActivity
  class CLI
    OPTION_REGEXP = Regexp.compile('^(--|-)(.+)=(.*)$')

    def self.start(argv)
      new(argv).run unless argv.size == 1
    end

    def initialize(argv)
      @command = argv[1]
      @options ||= {}
      parse_args(argv[2..-1])
    end

    def parse_args(args)
      args.each do |arg|
        option = OPTION_REGEXP.match(arg)
        @options[option[2].gsub('-', '_').to_sym] = option[3] if option
      end
    end

    def run
      case @command
      when 'today'                      then today
      when 'version', '--version', '-v' then version
      end
    end

    def today
      fetcher = Fetcher.new(@options)
      fetcher.today
    end

    def version
      puts "mruby-redmine_activity #{MrubyRedmineActivity::VERSION}"
    end
  end
end
