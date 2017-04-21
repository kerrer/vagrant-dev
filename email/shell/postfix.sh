apt-get install postfix postfix-mysql dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd dovecot-mysql

cp /etc/postfix/main.cf /etc/postfix/main.cf.orig

#Enter the following command to ensure that Postfix can find your first domain. Be sure to replace example.com with your first virtual domain. The command should return 1 if it is successful; if nothing is returned, you have an issue.
service postfix restart
postmap -q example.com mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf

#Test Postfix to verify that it can find the first email address in your MySQL table. Enter the following command, replacing email1@example.com with the first email address in your MySQL table. You should again receive 1 as the output:
service postfix restart
postmap -q email1@example.com mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf

#Test Postfix to verify that it can find your aliases by entering the following command. Be sure to replace alias@example.com with the actual alias you entered:
service postfix restart
postmap -q alias@example.com mysql:/etc/postfix/mysql-virtual-alias-maps.cf


cp /etc/postfix/master.cf /etc/postfix/master.cf.orig



cp /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf.orig
cp /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.orig
cp /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.orig
cp /etc/dovecot/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext.orig
cp /etc/dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf.orig
cp /etc/dovecot/conf.d/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf.orig
