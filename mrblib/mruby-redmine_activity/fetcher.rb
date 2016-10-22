module MrubyRedmineActivity
  class Fetcher
    COLORS         = { red: "\e[31m", yellow: "\e[33m", cyan: "\e[36m", reset: "\e[0m" }
    TOKEN          = /<input type="hidden" name="authenticity_token" value="(.+)" \/>/
    ENTRY          = /<entry>.+?<\/entry>/m
    TITLE          = /<title>(.+)<\/title>/
    PROJECT_TITLE  = /(.+):/
    NAME           = /<name>(.+)<\/name>/
    UPDATED        = /<updated>(.+)<\/updated>/
    TIME           = /(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z/
    DATE_SEPARATOR = /-|\/|\./

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
        authenticity_token: login_page_response.body[TOKEN, 1]
      }
    end

    def top_page_request_headers(login_page_response)
      { 'Cookie' => login_page_response.headers['set-cookie'] }
    end

    def activity_atom_url
      project = "/projects/#{@project}" if @project
      from = "&from=#{@date}" if @date
      user_id = "&user_id=#{@user_id}" if @user_id
      "#{@url}#{project}/activity.atom?show_issues=1#{from}#{user_id}"
    end

    def activity_atom_request_headers(top_page_response)
      { 'Cookie' => top_page_response.headers['set-cookie'] }
    end

    def parse(xml)
      project_title = xml[TITLE, 1][PROJECT_TITLE, 1]

      xml.scan(ENTRY) do |entry|
        updated = entry[UPDATED, 1]
        updated_time = utc_time(updated)

        next unless cover?(updated_time)

        title = entry[TITLE, 1]
        title = "#{project_title} - #{title}" if @project
        name = entry[NAME, 1]
        output_summary(title, name, updated)
      end
    end

    def utc_time(time_str)
      match = TIME.match(time_str)
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
        time = Time.local(*@date.split(DATE_SEPARATOR).map { |d| d.to_i })
      else
        time = Time.now
      end

      beginning_of_day = Time.local(time.year, time.month, time.day).utc
      end_of_day = Time.local(time.year, time.month, time.day, 23, 59, 59).utc
      @time_range = beginning_of_day..end_of_day
    end

    def output_summary(title, name, updated)
      puts "#{COLORS[:yellow]}#{title}#{COLORS[:reset]} #{COLORS[:cyan]}(#{name})#{COLORS[:reset]} (#{updated})"
    end
  end
end
