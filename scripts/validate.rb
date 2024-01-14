
class Validate
    def initialize
        @errors = []
    end

    # 指定したバージョンより新しいバージョンが存在するかどうか
    def latest_version(latest_version, current_version)
        current_version_parts = current_version.split('.').map(&:to_i)
        latest_version_parts = latest_version.split('.').map(&:to_i)

        latest_version_parts.each_with_index do |part, index|
            return true if part > current_version_parts[index]
            return false if part < current_version_parts[index]
        end

        false
    end
end
