module GoogleSheetApi
  class Client
    include ::GoogleSheetApi::Constants

    def initialize
    end

    # def self.compatible_api_version
    #   'v1'
    # end

    # This is the version of the API docs this client was built off-of
    def self.api_version
      'v1 2023-08-29'
    end

    # TODO: Allow sheet id and url
    def get_sheet_data(sheet_url, type: 'csv', limit: REDIRECT_LIMIT, redirect: false)
      url = parse_sheet_url(sheet_url, sheet_export(type), redirect: redirect)
      uri = URI(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      case response
      when Net::HTTPSuccess     then parse(response, type)
      when Net::HTTPRedirection then get_sheet_data(response['location'], type: type, limit: limit - 1, redirect: true)
      else
        response.error!
      end
    end

    def get_form(form_url, limit: REDIRECT_LIMIT, redirect: false)
      uri = URI(form_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then get_form(response['location'], limit: limit - 1, redirect: true)
      else
        response.error!
      end
    end

    # TODO: Possibly combine get_form_inputs and get_post_form_url
    # Returns a hash where the key is the human readable key and the value is the
    # form input identifier
    #
    # Use the keys to construct your payloads
    #
    def get_form_inputs(form_url)
      raw_form = get_form(form_url).body
      raw_variable_output = JSON.parse(raw_form.match(/FB_PUBLIC_LOAD_DATA_ = (.*);/)[1])

      # We ignore everything that isn't an input
      # TODO: Possibly add in the option to return all text?

      raw_form_inputs = raw_variable_output[1][1].compact

      raw_form_inputs.map do |input|
        [input[1], input[4][0][0]]
      end.to_h
    end

    def get_post_form_url(form_url)
      raw_form = get_form(form_url).body
      raw_variable_output = JSON.parse(raw_form.match(/FB_PUBLIC_LOAD_DATA_ = (.*);/)[1])
      form_id = raw_variable_output[-5]

      "https://docs.google.com/forms/d/#{form_id}/formResponse"
    end

    # TODO: Cleanup parameters
    def submit_form(form_url, form_post_url, payload_object:, limit: REDIRECT_LIMIT, redirect: false)
      payload_object = get_form_mapping(form_url, payload_object)

      uri = URI(form_post_url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri)
      request.set_form_data(payload_object)

      response = http.request(request)

      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then submit_form(response['location'], payload_object, limit: limit - 1, redirect: true)
      else
        response.error!
      end
    end

    private

    def parse(response, type)
      if type == 'csv'
        # Split the sheet into an array
        outer_array = response.body.split("\n")
        outer_array.map do |line|
          cleanup(line).split(',')
        end
      elsif type == 'json'
        JSON.parse(response.body)
      else
        response # You need to deal with it
      end
    end

    def sheet_export(type)
      "export?usp=sharing&format=#{type}"
    end

    def parse_sheet_url(url, new_action, redirect: false)
      return url if redirect

      parts = url.split("/")

      if parts.size == 6 && url.to_s[-1] != "/" # no action
        "#{url}/#{new_action}"
      elsif parts.size == 6 && url.to_s[-1] == "/" # no action
        "#{url}#{new_action}"
      else
        "#{parts[0]}//#{parts[2]}/#{parts[3]}/#{part[4]}/#{parts[5]}/#{new_action}"
      end
    end

    def get_form_mapping(form_url, payload)
      raw_form_response = get_form(form_url)
      body = raw_form_response.body.to_s

      mapping_hash = {}

      payload.keys.each do |header|
        header_regex = regex_to_find_key(header)

        raw_value = body[header_regex]
        mapping_hash["entry.#{raw_value[NUMBER_REGEX]}"] = payload[header]
      end

      mapping_hash
    end

    def regex_to_find_key(header)
      Regexp.new("(?-mix:(#{header})\\S+)")
    end

    def cleanup(data)
      CLEANUP_PATTERNS.each do |pattern|
        data = data.to_s.gsub(*pattern)
      end

      data
    end
  end
end
