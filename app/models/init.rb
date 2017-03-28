
def json_prs(records, options)
  return JSON.parse( records.to_json( options ) )
end


require_relative 'camp'
require_relative 'help_contact'
require_relative 'journey'
require_relative 'preset_message'
require_relative 'shift'
require_relative 'shift_event'
require_relative 'station'
require_relative 'train_schedule'
require_relative 'user'
require_relative 'registered_device'
require_relative 'journey_location'
require_relative 'user_location'
require_relative 'plot'
require_relative 'station_location'
require_relative 'ibeacon'
require_relative 'panic'
require_relative 'user_event'
require_relative 'journey_event'
require_relative 'device_app'
require_relative 'beacon'

#mailer
require_relative 'mailer'
