module MrubyRedmineActivity
  class Fetcher
    COLORS         = { red: "\e[31m", yellow: "\e[33m", reset: "\e[0m" }
    TOKEN_REGEXP   = Regexp.compile('<input type="hidden" name="authenticity_token" value="(.+)" />')
    COOKIE_REGEXP  = Regexp.compile('(_redmine_session.+); path=/; HttpOnly')
    ENTRY_REGEXP   = Regexp.compile('<entry>.+?</entry>', Regexp::MULTILINE)
    TITLE_REGEXP   = Regexp.compile('<title>(.+)</title>')
    UPDATED_REGEXP = Regexp.compile('<updated>(.+)</updated>')
    TIME_REGEXP    = Regexp.compile('(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z')

    def initialize(options = {})
      @url      = ENV['REDMINE_ACTIVITY_URL']
      @login_id = ENV['REDMINE_ACTIVITY_LOGIN_ID']
      @password = ENV['REDMINE_ACTIVITY_PASSWORD']

      options.each do |key, value|
        instance_variable_set(:"@#{key}", value)
      end
    end

    def get
      agent                  = HttpRequest.new
      login_page_response    = agent.get(login_url)
      top_page_response      = agent.post(login_url, top_page_request_params(login_page_response), top_page_request_headers(login_page_response))
      activity_atom_response = agent.get(activity_atom_url, nil, activity_atom_request_headers(top_page_response))

      if activity_atom_response.code == 404
        puts "#{COLORS[:red]}404 Not Found.#{COLORS[:reset]}"
      else
        parse(activity_atom_response.body)
      end
    end

    def login_url
      "#{@url}/login"
    end

    def top_page_request_params(login_page_response)
      {
        username: @login_id,
        password: @password,
        authenticity_token: TOKEN_REGEXP.match(login_page_response.body)[1]
      }
    end

    def top_page_request_headers(login_page_response)
      { 'Cookie' => COOKIE_REGEXP.match(login_page_response.headers['set-cookie'])[1] }
    end

    def activity_atom_url
      from = "&from=#{@date}" if @date
      user_id = "&user_id=#{@user_id}" if @user_id
      "#{@url}/activity.atom?show_issues=1#{from}#{user_id}"
    end

    def activity_atom_request_headers(top_page_response)
      { 'Cookie' => COOKIE_REGEXP.match(top_page_response.headers['set-cookie'])[1] }
    end

    def parse(xml)
      xml.scan(ENTRY_REGEXP) do |entry|
        title = TITLE_REGEXP.match(entry)[1]
        updated = UPDATED_REGEXP.match(entry)[1]
        updated_time = utc_time(updated)

        puts "#{COLORS[:yellow]}#{title}#{COLORS[:reset]} (#{updated})" if cover?(updated_time)
      end
    end

    def utc_time(time_str)
      match = TIME_REGEXP.match(time_str)
      year  = match[1].to_i
      month = match[2].to_i
      day   = match[3].to_i
      hour  = match[4].to_i
      min   = match[5].to_i
      sec   = match[6].to_i
      Time.utc(year, month, day, hour, min, sec)
    end

    def cover?(time)
      time_range.include?(time)
    end

    def time_range
      return @time_range if @time_range

      if @date
        time = Time.local(*@date.split(/-|\/|\./).map { |d| d.to_i })
      else
        time = Time.now
      end

      beginning_of_day = Time.local(time.year, time.month, time.day).utc
      end_of_day = Time.local(time.year, time.month, time.day, 23, 59, 59).utc
      @time_range = beginning_of_day..end_of_day
    end
  end
end
