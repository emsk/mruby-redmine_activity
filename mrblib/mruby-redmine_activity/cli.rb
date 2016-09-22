module MrubyRedmineActivity
  class CLI
    OPTION_REGEXP = Regexp.compile('^(--|-)(.+)=(.*)$')

    def self.start(argv)
      if argv.size == 1
        Help.new.run
      else
        new(argv).run
      end
    end

    def initialize(argv)
      @command = argv[1]
      @text ||= ''
      @options ||= {}
      parse_args(argv[2..-1])
    end

    def parse_args(args)
      args.each do |arg|
        option = OPTION_REGEXP.match(arg)
        if option
          @options[option[2].gsub('-', '_').to_sym] = option[3]
        else
          @text = arg
        end
      end
    end

    def run
      case @command
      when 'today'                      then today
      when 'version', '--version', '-v' then version
      when 'help'                       then help(@text)
      else                                   help
      end
    end

    def today
      fetcher = Fetcher.new(@options)
      fetcher.today
    end

    def version
      puts "mruby-redmine_activity #{MrubyRedmineActivity::VERSION}"
    end

    def help(command = nil)
      Help.new(command).run
    end
  end
end
