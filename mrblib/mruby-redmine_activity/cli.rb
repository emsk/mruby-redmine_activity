module MrubyRedmineActivity
  class CLI
    OPTION = /^(--|-)(.+)=(.*)$/

    def self.start(argv)
      new(argv).run
    end

    def initialize(argv)
      @command = command?(argv[1]) ? argv[1] : 'get'
      @text ||= ''
      @options ||= {}
      parse_args(argv[1..-1])
    end

    def command?(arg)
      arg && !OPTION.match(arg)
    end

    def parse_args(args)
      args.each do |arg|
        option = OPTION.match(arg)
        if option
          @options[option[2].gsub('-', '_').to_sym] = option[3]
        else
          @text = arg
        end
      end
    end

    def run
      case @command
      when 'get'                        then get
      when 'today'                      then today
      when 'yesterday'                  then yesterday
      when 'version', '--version', '-v' then version
      when 'help'                       then help(@text)
      else                                   help
      end
    end

    def get
      fetcher = Fetcher.new(@options)
      fetcher.get
    end

    def today
      @options.key?(:date) ? help(@command) : get
    end

    def yesterday
      return help(@command) if @options.key?(:date)

      time = Time.now - 86400
      @options[:date] = "#{time.year}-#{time.month}-#{time.day}"
      get
    end

    def version
      puts "mruby-redmine_activity #{MrubyRedmineActivity::VERSION}"
    end

    def help(command = nil)
      Help.new(command).run
    end
  end
end
