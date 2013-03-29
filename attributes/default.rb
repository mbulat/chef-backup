default[:backup][:backup_user] = 'ubuntu'

default[:backup][:name] = "server_backup"
default[:backup][:description] = "a chef generated server backup"


default[:backup][:database][:username] = 'admin_user'
default[:backup][:database][:host] = 'credrock'
default[:backup][:database][:databases] = ['credrock']
default[:backup][:database][:port] = 5432

default[:backup][:s3][:bucket_region] = 'us-east-1'
default[:backup][:s3][:path] = 'credrock'
default[:backup][:s3][:bucket_name] = 'credrock_db_backups'
default[:backup][:s3][:keep] = '100'

default[:backup][:scp][:username] = "crback"
default[:backup][:scp][:host] = "fw.tidewinds.com"
default[:backup][:scp][:port] = "22"
default[:backup][:scp][:path] = "~/hole/"
default[:backup][:scp][:keep] = 100

# Create this beforehand

default[:backup][:mail][:on_success] = false
default[:backup][:mail][:on_failure] = true
default[:backup][:mail][:from_address] = "mbulat@credrock.com"
default[:backup][:mail][:to_address] = "mbulat@credrock.com"
default[:backup][:mail][:domain] = "credrock.com"
