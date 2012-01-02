#
# Cookbook Name:: initdb
# Recipe:: default
#
# Copyright 2012, xforty technologies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "database"

providers = {
  :mysql => {
    :database => Chef::Provider::Database::Mysql,
    :user     => Chef::Provider::Database::MysqlUser
  },
  :postgresql => {
    :database => Chef::Provider::Database::Postgresql,
    :user     => Chef::Provider::Database::PostgresqlUser
  },
  :sqlserver => {
    :database => Chef::Provider::Database::SqlServer,
    :user     => Chef::Provider::Database::SqlServerUser
  }
}

if node.has_key?(:initdb)
  # execute provider actions
  node[:initdb].each do |db_provider_symbol,db_provider|

    # execute database actions
    if db_provider.has_key?(:databases)
      db_provider[:databases].each do |db_name,db|
        database db_name do
          action           db[:action]
          connection       db_provider[:connection]
          connection_limit db[:connection_limit]
          encoding         db[:encoding]
          owner            db[:owner]
          provider         providers[:"#{db_provider_symbol}"][:database]
          sql              db[:sql]
          tablespace       db[:tablespace]
          template         db[:template]
        end
      end
    end
    
    # execute user actions
    if db_provider.has_key?(:users)
      db_provider[:users].each do |db_username,db_user|
        database_user db_username do
          action        db_user[:action]
          connection    db_provider[:connection]
          database_name db_user[:database_name]
          host          db_user[:host]
          password      db_user[:password]
          privileges    db_user[:privileges]
          provider      providers[:"#{db_provider_symbol}"][:user]
          table         db_user[:table]
        end
      end
    end
  end
end
