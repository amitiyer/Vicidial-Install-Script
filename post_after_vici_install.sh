#!/bin/bash
echo
echo
echo
echo "=========By Amit Iyer================";
echo "=========amitiyer@hotmail.com========";
echo "Vicidial Custom Install CentOS 7.";

echo

sleep 3
#GET SERVER IP
serverip=$(dig +short myip.opendns.com @resolver1.opendns.com)
echo "server IP : $serverip";

sleep 3

cd /usr/share/astguiclient/
/usr/share/astguiclient/ADMIN_area_code_populate.pl
/usr/share/astguiclient/ADMIN_update_server_ip.pl --old-server_ip=10.10.10.15 --server_ip=$serverip


echo "
### recording mixing/compressing/ftping scripts
#0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57 * * * * /usr/share/astguiclient/AST_CRON_audio_1_move_mix.pl
0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57 * * * * /usr/share/astguiclient/AST_CRON_audio_1_move_mix.pl --MIX
0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57 * * * * /usr/share/astguiclient/AST_CRON_audio_1_move_VDonly.pl
1,4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58 * * * * /usr/share/astguiclient/AST_CRON_audio_2_compress.pl --MP3 --HTTPS
#2,5,8,11,14,17,20,23,26,29,32,35,38,41,44,47,50,53,56,59 * * * * /usr/share/astguiclient/AST_CRON_audio_3_ftp.pl --MP3
### keepalive script for astguiclient processes
* * * * * /usr/share/astguiclient/ADMIN_keepalive_ALL.pl --cu3way
### kill Hangup script for Asterisk updaters
* * * * * /usr/share/astguiclient/AST_manager_kill_hung_congested.pl
### updater for voicemail
* * * * * /usr/share/astguiclient/AST_vm_update.pl
### updater for conference validator
* * * * * /usr/share/astguiclient/AST_conf_update.pl
### flush queue DB table every hour for entries older than 1 hour
11 * * * * /usr/share/astguiclient/AST_flush_DBqueue.pl -q
### fix the vicidial_agent_log once every hour and the full day run at night
33 * * * * /usr/share/astguiclient/AST_cleanup_agent_log.pl
50 0 * * * /usr/share/astguiclient/AST_cleanup_agent_log.pl --last-24hours
## uncomment below if using QueueMetrics
#*/5 * * * * /usr/share/astguiclient/AST_cleanup_agent_log.pl --only-qm-live-call-check
## uncomment below if using Vtiger
#1 1 * * * /usr/share/astguiclient/Vtiger_optimize_all_tables.pl --quiet
### updater for VICIDIAL hopper
* * * * * /usr/share/astguiclient/AST_VDhopper.pl -q
### adjust the GMT offset for the leads in the vicidial_list table
1 1,7 * * * /usr/share/astguiclient/ADMIN_adjust_GMTnow_on_leads.pl --debug
### reset several temporary-info tables in the database
2 1 * * * /usr/share/astguiclient/AST_reset_mysql_vars.pl
### optimize the database tables within the asterisk database
3 1 * * * /usr/share/astguiclient/AST_DB_optimize.pl
## adjust time on the server with ntp
#30 * * * * /usr/sbin/ntpdate -u pool.ntp.org 2>/dev/null 1>&amp;2
### VICIDIAL agent time log weekly and daily summary report generation
2 0 * * 0 /usr/share/astguiclient/AST_agent_week.pl
22 0 * * * /usr/share/astguiclient/AST_agent_day.pl
### VICIDIAL campaign export scripts (OPTIONAL)
#32 0 * * * /usr/share/astguiclient/AST_VDsales_export.pl
#42 0 * * * /usr/share/astguiclient/AST_sourceID_summary_export.pl
### remove old recordings
#24 0 * * * /usr/bin/find /var/spool/asterisk/monitorDONE -maxdepth 2 -type f -mtime +7 -print | xargs rm -f
#26 1 * * * /usr/bin/find /var/spool/asterisk/monitorDONE/MP3 -maxdepth 2 -type f -mtime +65 -print | xargs rm -f
#25 1 * * * /usr/bin/find /var/spool/asterisk/monitorDONE/FTP -maxdepth 2 -type f -mtime +1 -print | xargs rm -f
24 1 * * * /usr/bin/find /var/spool/asterisk/monitorDONE/ORIG -maxdepth 2 -type f -mtime +1 -print | xargs rm -f
### roll logs monthly on high-volume dialing systems
#30 1 1 * * /usr/share/astguiclient/ADMIN_archive_log_tables.pl
### remove old vicidial logs and asterisk logs more than 2 days old
28 0 * * * /usr/bin/find /var/log/astguiclient -maxdepth 1 -type f -mtime +2 -print | xargs rm -f
29 0 * * * /usr/bin/find /var/log/asterisk -maxdepth 3 -type f -mtime +2 -print | xargs rm -f
30 0 * * * /usr/bin/find / -maxdepth 1 -name "screenlog.0*" -mtime +4 -print | xargs rm -f
### cleanup of the scheduled callback records
25 0 * * * /usr/share/astguiclient/AST_DB_dead_cb_purge.pl --purge-non-cb -q
### GMT adjust script - uncomment to enable
#45 0 * * * /usr/share/astguiclient/ADMIN_adjust_GMTnow_on_leads.pl --list-settings
### Dialer Inventory Report
1 7 * * * /usr/share/astguiclient/AST_dialer_inventory_snapshot.pl -q --override-24hours
### inbound email parser
* * * * * /usr/share/astguiclient/AST_inbound_email_parser.pl
### Daily Reboot
#30 6 * * * /sbin/Reboot
" >> /var/spool/cron/root

cp -R /usr/src/rc.local /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local
systemctl enable rc-local
systemctl start rc-local

cd /usr/src/vicidial
tar -zxf /usr/src/asterisk-core-sounds-en-gsm-current.tar.gz
tar -zxf /usr/src/asterisk-core-sounds-en-ulaw-current.tar.gz
tar -zxf /usr/src/asterisk-core-sounds-en-wav-current.tar.gz
tar -zxf /usr/src/asterisk-extra-sounds-en-gsm-current.tar.gz
tar -zxf /usr/src/asterisk-extra-sounds-en-ulaw-current.tar.gz
tar -zxf /usr/src/asterisk-extra-sounds-en-wav-current.tar.gz
mkdir /var/lib/asterisk/mohmp3
mkdir /var/lib/asterisk/quiet-mp3
ln -s /var/lib/asterisk/mohmp3 /var/lib/asterisk/default
cd /var/lib/asterisk/mohmp3
tar -zxf /usr/src/asterisk-moh-opsound-gsm-current.tar.gz
tar -zxf /usr/src/asterisk-moh-opsound-ulaw-current.tar.gz
tar -zxf /usr/src/asterisk-moh-opsound-wav-current.tar.gz
rm -f CHANGES*
rm -f LICENSE*
rm -f CREDITS*
cd /var/lib/asterisk/moh
rm -f CHANGES*
rm -f LICENSE*
rm -f CREDITS*
cd /var/lib/asterisk/sounds
rm -f CHANGES*
rm -f LICENSE*
rm -f CREDITS*
cd /var/lib/asterisk/quiet-mp3
sox ../mohmp3/macroform-cold_day.wav macroform-cold_day.wav vol 0.25
sox ../mohmp3/macroform-cold_day.gsm macroform-cold_day.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/macroform-cold_day.ulaw -t ul macroform-cold_day.ulaw vol 0.25
sox ../mohmp3/macroform-robot_dity.wav macroform-robot_dity.wav vol 0.25
sox ../mohmp3/macroform-robot_dity.gsm macroform-robot_dity.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/macroform-robot_dity.ulaw -t ul macroform-robot_dity.ulaw vol 0.25
sox ../mohmp3/macroform-the_simplicity.wav macroform-the_simplicity.wav vol 0.25
sox ../mohmp3/macroform-the_simplicity.gsm macroform-the_simplicity.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/macroform-the_simplicity.ulaw -t ul macroform-the_simplicity.ulaw vol 0.25
sox ../mohmp3/reno_project-system.wav reno_project-system.wav vol 0.25
sox ../mohmp3/reno_project-system.gsm reno_project-system.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/reno_project-system.ulaw -t ul reno_project-system.ulaw vol 0.25
sox ../mohmp3/manolo_camp-morning_coffee.wav manolo_camp-morning_coffee.wav vol 0.25
sox ../mohmp3/manolo_camp-morning_coffee.gsm manolo_camp-morning_coffee.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/manolo_camp-morning_coffee.ulaw -t ul manolo_camp-morning_coffee.ulaw vol 0.25


#DISABLE FIREWALL
systemctl stop firewalld
systemctl disable firewall


reboot
