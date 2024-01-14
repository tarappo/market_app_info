require 'net/http'
require 'json'
require 'time'

class AppStoreMarket
  def initialize()
  end

  def get_app_info(bundle_id)
    uri = URI("https://itunes.apple.com/lookup?bundleId=#{bundle_id}")
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
  
    raise("No app found with the provided bundle id") if json['resultCount'] == 0
  
    app_info = json['results'].first
    raise("No app found with the provided bundle id") if app_info.nil?
  
    release_date = Time.parse(app_info['currentVersionReleaseDate']).getlocal("+09:00")
    formatted_date = release_date.strftime("%Y年%m月%d日 %H時%M分%S秒")  
    {
      "app_name" => app_info['trackName'],
      "release_date" => formatted_date,
      "version" => app_info['version'],
    }
  end
end

# 'com.facebook.Facebook'
bundle_id = ARGV[0]
raise("Please provide a bundle id") if bundle_id.nil?
puts AppStoreMarket.new.get_app_info(bundle_id)
