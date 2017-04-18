
def json_prs(records, options)
  return JSON.parse( records.to_json( options ) )
end

require_relative 'help_contact'
require_relative 'user'
