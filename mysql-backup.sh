#!/bin/bash
storia_env=$1
#S3 bucket credentials of vstplayground aws account.
export AWS_ACCESS_KEY_ID=AKIAIF5MBMNFVN24FMLQ
export AWS_SECRET_ACCESS_KEY=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
source env_$storia_env.sh
bucket=$S3bucket
YEAR=$(date +"%Y")
MONTH=$(date +"%m")
DAY=$(date +"%d")
S3Bucket=s3://$bucket/$YEAR/$MONTH/$DATE/
dbuser=$DBUSER
dbpasswd=$DBPASSWD
appdbhost=$AppDBHOST
admindbhost=$AdminDBHOST
authdbhost=$AuthDBHOST
dicdbhost=$DicDBHOST
entdbhost=$EntDBHOST
logdbhost=$LogDBHOST
datadbhost=$DataDBHOST
appdatabase=$AppDATABASE
admindatabase=$AdminDATABASE
authdatabase=$AuthDATABASE
dicdatabase=$DicDATABASE
entdatabase=$EntDATABASE
logdatabase=$LogDATABASE
datadatabase=$DataDATABASE
 
/usr/bin/mysqldump -u $dbuser -h $appdbhost -p$dbpasswd $appdatabase  > mysql-backup/$appdatabase.sql
/usr/bin/mysqldump -u $dbuser -h $admindbhost -p$dbpasswd $admindatabase  > mysql-backup/$admindatabase.sql
/usr/bin/mysqldump -u $dbuser -h $authdbhost -p$dbpasswd $authdatabase  > mysql-backup/$authdatabase.sql
/usr/bin/mysqldump -u $dbuser -h $dicdbhost -p$dbpasswd $dicdatabase  > mysql-backup/$dicdatabase.sql
/usr/bin/mysqldump -u $dbuser -h $entdbhost -p$dbpasswd $entdatabase  > mysql-backup/$entdatabase.sql
/usr/bin/mysqldump -u $dbuser -h $logdbhost -p$dbpasswd $logdatabase  > mysql-backup/$logdatabase.sql
/usr/bin/mysqldump -u $dbuser -h $datadbhost -p$dbpasswd $datadatabase  > mysql-backup/$datadatabase.sql
/bin/gzip $appdatabase-$(date +%Y%m%d).sql.gz  mysql-backup/$appdatabase.sql
/bin/gzip $admindatabase-$(date +%Y%m%d).sql.gz  mysql-backup/$admindatabase.sql
/bin/gzip $authdatabase-$(date +%Y%m%d).sql.gz  mysql-backup/$authdatabase.sql
/bin/gzip $dicdatabase-$(date +%Y%m%d).sql.gz  mysql-backup/$dicdatabase.sql
/bin/gzip $entdatabase-$(date +%Y%m%d).sql.gz  mysql-backup/$entdatabase.sql
/bin/gzip $logdatabase-$(date +%Y%m%d).sql.gz  mysql-backup/$logdatabase.sql
/bin/gzip $datadatabase-$(date +%Y%m%d).sql.gz  mysql-backup/$datadatabase.sql

#if successful create zip file of dump database
if [ $? -eq 0 ]; then

aws s3 cp $appdatabase-$(date +%Y%m%d).sql.gz  $S3Bucket  2>&1 >> /var/s3-upload.log
aws s3 cp $admindatabase-$(date +%Y%m%d).sql.gz  $S3Bucket  2>&1 >> /var/s3-upload.log
aws s3 cp $authdatabase-$(date +%Y%m%d).sql.gz  $S3Bucket  2>&1 >> /var/s3-upload.log
aws s3 cp $dicdatabase-$(date +%Y%m%d).sql.gz  $S3Bucket  2>&1 >> /var/s3-upload.log
aws s3 cp $entdatabase-$(date +%Y%m%d).sql.gz  $S3Bucket  2>&1 >> /var/s3-upload.log
aws s3 cp $logdatabase-$(date +%Y%m%d).sql.gz  $S3Bucket  2>&1 >> /var/s3-upload.log
aws s3 cp $datadatabase-$(date +%Y%m%d).sql.gz  $S3Bucket  2>&1 >> /var/s3-upload.log

fi
