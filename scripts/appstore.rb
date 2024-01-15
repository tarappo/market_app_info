require 'net/http'
require 'json'
require 'time'
require_relative 'validate'

class AppStoreMarket
  def initialize()
  end

  def get_app_info(country_code, bundle_id)
    uri = URI("https://itunes.apple.com/#{country_code}/lookup?bundleId=#{bundle_id}")
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
  
    raise("No app found with the provided bundle id") if json['resultCount'] == 0
  
    app_info = json['results'].first
    raise("No app found with the provided bundle id") if app_info.nil?
  
    current_version_release_date = app_info['currentVersionReleaseDate']
    release_date = Time.parse(current_version_release_date).getlocal("+09:00")
    formatted_date = release_date.strftime("%Y/%m/%d %H:%M:%S")
    {
      "app_name" => app_info['trackName'],
      "release_date" => current_version_release_date,
      "release_formatted_date" => formatted_date,
      "version" => app_info['version'],
    }
  end
end

# parameters
country_code = ARGV[0]
bundle_id = ARGV[1]
version_number = ARGV[2]
raise("Please provide a bundle id") if bundle_id.nil?

# アプリの情報の取得
app_info = AppStoreMarket.new.get_app_info(country_code, bundle_id)

# 新バージョンが出てるかの確認をする場合
unless version_number.nil?
  new_version_flag = Validate.new.latest_version(app_info['version'], version_number)
  app_info = {} unless new_version_flag
end

puts app_info.to_json
