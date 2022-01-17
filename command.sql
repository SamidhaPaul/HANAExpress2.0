ALTER SYSTEM ALTER CONFIGURATION ('global.ini', 'system') SET ('public_hostname_resolution', 'use_default_route') = 'name' WITH RECONFIGURE;
ALTER SYSTEM ALTER CONFIGURATION ('global.ini', 'system') SET ('public_hostname_resolution', 'map_hxehost') = '192.168.99.100' WITH RECONFIGURE;

CREATE DATABASE TST SYSTEM USER PASSWORD Initial1;
ALTER DATABASE TST ADD 'scriptserver'