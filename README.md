chef-initdb
===========
version 1.0.1 - [changelog](https://github.com/xforty/chef-initdb/blob/master/CHANGELOG.md)

### Description

Executes specified actions on a database server.  This is a concrete
cookbook for Opscode's `database` cookbook.  Meaning, you can use
this cookbook to actually execute actions defined in the `database`
cookbook.  You could always create a site-specific cookbook for these
actions, but this generic cookbook is a simple enough abstraction that
can be re-used.

### Requirements

See [metadata.rb](https://github.com/xforty/chef-initdb/blob/master/metadata.rb)

### Attributes

None

### Usage

All the options from the `database` cookbook are available here. Those
options are passed directly on to the `database` cookbook. See the
[database documentation](http://community.opscode.com/cookbooks/database)
for more info on the options that are optional and have default
values or those that require specific formats. All hash keys are strings.
All hash values are either strings or integers.

All actions are contained inside the `initdb` hash.

    'initdb' => {
      <provider1> => { },
      [provider2] => { },
      [provider3] => { }
    }

Multiple provider hashes can be specified if you need to connect
to multiple database servers.  Specify the provider using
`mysql`, `postgresql`, or `sqlserver`.

    'initdb' => {
      'mysql' => {
        'connection' => { },
        'databases'  => { },
        'users'      => { }
      },
      'postgresql' => {
        'connection' => { },
        'databases'  => { },
        'users'      => { }
      },
      'sqlserver' => {
        'connection' => { },
        'databases'  => { },
        'users'      => { }
      }
    }

By default, the `connection` parameters are used for both the executed database
and user actions.  If you want to use different connection parameters for the
user actions, just define another provider hash inside `initdb`. For example,
you can have multiple `mysql` provider hashes defined within `initdb`.

    'connection' => {
      'host'     => '',
      'password' => '',
      'port'     => '',
      'username' => ''
    }

Place your database definitions in the `databases` hash.

    'databases' => {
      '<database_name>' => {
        'action'           => '',
        'connection_limit' => '',
        'encoding'         => '',
        'owner'            => '',
        'sql'              => '',
        'tablespace'       => '',
        'template'         => ''
      }
    }

Place your database user definitions in the `users` hash.

    'users' => {
      '<username>' => {
        'action'        => '',
        'database_name' => '',
        'host'          => '',
        'password'      => '',
        'privileges'    => { },
        'table'         => ''
      }
    }

The Usage blocks from above displayed together:

    'initdb' => {
      '<provider>' => {
        'connection' => {
          'host'     => '',
          'password' => '',
          'port'     => '',
          'username' => ''
        },
        'databases' => {
          '<database_name>' => {
            'action'           => '',
            'connection_limit' => '',
            'encoding'         => '',
            'owner'            => '',
            'sql'              => '',
            'tablespace'       => '',
            'template'         => ''
          }
        },
        'users' => {
          '<username>' => {
            'action'        => '',
            'database_name' => '',
            'host'          => '',
            'password'      => '',
            'privileges'    => { },
            'table'         => ''
          }
        }
      }
    }

### Example

Create a database, create a user, and grant all privileges to the user
for the specified database in a MySQL server:

    'initdb' => {
      'mysql' => {
        'connection' => {
          'username' => 'root',
          'password' => 'root_pw',
          'host'     => 'localhost'
        },
        'databases' => {
          'my_test_db' => {
            'action' => 'create'
          }
        },
        'users' => {
          'test_user' => {
            'action'        => 'grant',
            'database_name' => 'my_test_db',
            'host'          => 'localhost',
            'password'      => 'secret_pw'
          }
        }
      }
    }
