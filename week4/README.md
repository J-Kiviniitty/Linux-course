Week 4
Features
Server B created from a snapshot of Server A
Hourly website backups using cron and rsync
Timestamped backups stored on Server B
Successful backup restoration test
MariaDB primary/replica replication
Read-only replica page on Server B
Backup
Server A backs up /var/www/html to:

/srv/backups/www

on Server B.

Replication
Server A acts as a MariaDB primary.

Server B acts as a MariaDB replica.

Pages
Primary: http://195.148.23.249/viikko2/

Replica: http://128.214.252.249/viikko4/
