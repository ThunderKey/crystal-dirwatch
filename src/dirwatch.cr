require "./dirwatch/user_friendly_exception"
require "./dirwatch/setting"

# A tool that watches directories and executes commands if files change
module Dirwatch
  # Run the dirwatcher with the configuraiton in "dirwatch.yml"
  def self.run
    all_settings = Setting.from_file "dirwatch.yml"
    p all_settings
  rescue e : UserFriendlyException
    puts e.readable_message
    exit 1
  end
end
