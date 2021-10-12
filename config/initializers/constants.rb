# frozen_string_literal: true

module Constants
  MAX_TASK_TITLE_LENGTH = 125
  is_sqlite_db = ActiveRecord::Base.connection_db_config.configuration_hash[:adapter] == "sqlite3"
  DB_REGEX_OPERATOR = is_sqlite_db ? "REGEXP" : "~*"
end
