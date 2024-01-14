require 'net/http'
require 'json'
require 'time'
require './scripts/validate.rb'

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

bundle_id = ARGV[0]
version_number = ARGV[1]
raise("Please provide a bundle id") if bundle_id.nil?

# アプリの情報の取得
app_info = AppStoreMarket.new.get_app_info(bundle_id)

# 新バージョンが出てるかの確認をする場合
unless version_number.nil?
  new_version_flag = Validate.new.latest_version(app_info['version'], version_number)
  app_info = {} unless new_version_flag
end

puts app_info.to_json
