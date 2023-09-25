-- Add Backends
INSERT INTO mysql_servers(hostgroup_id,hostname,port) VALUES (1,'mysql-master',3306);
INSERT INTO mysql_servers(hostgroup_id,hostname,port) VALUES (1,'mysql-slave-1',3306);
INSERT INTO mysql_servers(hostgroup_id,hostname,port) VALUES (1,'mysql-slave-2',3306);
SELECT * FROM mysql_servers;

-- Load MySQL variables
UPDATE global_variables SET variable_value='monitor' WHERE variable_name='mysql-monitor_username';
UPDATE global_variables SET variable_value='monitor' WHERE variable_name='mysql-monitor_password';
UPDATE global_variables SET variable_value='2000' WHERE variable_name IN ('mysql-monitor_connect_interval',
'mysql-monitor_ping_interval','mysql-monitor_read_only_interval');
SELECT * FROM global_variables WHERE variable_name LIKE 'mysql-monitor_%';
LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;

LOAD MYSQL SERVERS TO RUNTIME;

--Load Replication
INSERT INTO mysql_replication_hostgroups (writer_hostgroup,reader_hostgroup,comment) VALUES (10,20,'cluster1');

SELECT * FROM monitor.mysql_server_read_only_log ORDER BY time_start_us DESC LIMIT 3;
SELECT * FROM mysql_servers;

SAVE MYSQL SERVERS TO DISK;
SAVE MYSQL VARIABLES TO DISK;

-- Load MySQL users
INSERT INTO mysql_users(username,password,default_hostgroup) VALUES ('root','password',10);
LOAD MYSQL USERS TO RUNTIME;
SAVE MYSQL USERS TO DISK;

SHOW TABLES FROM stats;
SELECT * FROM stats.stats_mysql_connection_pool;
SELECT * FROM stats_mysql_commands_counters WHERE Total_cnt;
SELECT * FROM stats_mysql_query_digest ORDER BY sum_time DESC;
SELECT hostgroup hg, sum_time, count_star, digest_text FROM stats_mysql_query_digest ORDER BY sum_time DESC;

-- Load Query Rules
INSERT INTO mysql_query_rules (rule_id,active,match_pattern,destination_hostgroup,apply) VALUES (100,1,'^SELECT .* FOR UPDATE',10,1);
INSERT INTO mysql_query_rules (rule_id,active,match_pattern,destination_hostgroup,apply) VALUES (200,1,'^SELECT .*',20,1);
INSERT INTO mysql_query_rules (rule_id,active,match_pattern,destination_hostgroup,apply) VALUES (300,1,'.*',10,1);

LOAD MYSQL QUERY RULES TO RUNTIME;
SAVE MYSQL QUERY RULES TO DISK;