require 'active_record'

####
## Setup local postgres database
####

DATABASE_NAME = 'ohana_api_development'

connection_options = {
  adapter: "postgresql",
  username: 'etoro',
  encoding: 'utf8'
}

ActiveRecord::Base.establish_connection(connection_options)
ActiveRecord::Base.connection.drop_database DATABASE_NAME
ActiveRecord::Base.connection.create_database DATABASE_NAME

ActiveRecord::Base.establish_connection(
  connection_options.merge!(database: DATABASE_NAME))

# https://github.com/codeforamerica/ohana-api/blob/master/db/structure.sql
ActiveRecord::Base.connection.execute(File.read('structure.sql'))
