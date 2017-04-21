FROM ubuntu:14.04
MAINTAINER MaxKerrer "maxkerrer@126.com"

RUN mv /etc/apt/sources.list /etc/apt/sources.list.ori
ADD ./sources.list.trusty /etc/apt/sources.list

#RUN locale-gen zh_CN.UTF-8
#RUN update-locale LANG=zh_CN.UTF-8 LC_MESSAGES=POSIX
#RUN dpkg-reconfigure  --frontend noninteractive locales

RUN apt-get -y update 

###############ssh#############################

RUN  DEBIAN_FRONTEND=noninteractive apt-get install -y ssh

# Add vagrant user and key
ADD ./vagrant.pub /tmp/vagrant.pub
RUN useradd --create-home -s /bin/bash vagrant
RUN echo -n 'vagrant:vagrant' | chpasswd
RUN echo 'vagrant ALL = NOPASSWD: ALL' > /etc/sudoers.d/vagrant
RUN chmod 440 /etc/sudoers.d/vagrant
RUN mkdir -p /home/vagrant/.ssh
RUN chmod 700 /home/vagrant/.ssh
RUN cat /tmp/vagrant.pub >> /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh
RUN sed -i -e 's/Defaults.*requiretty/#&/' /etc/sudoers
RUN sed -i -e 's/\(UsePAM \)yes/\1 no/' /etc/ssh/sshd_config

RUN mkdir /var/run/sshd
EXPOSE 22

## We need openssh clients to enable file transfer over scp
RUN apt-get -y install openssh-client

#########################################################

#RUN  LC_ALL=zh_CN.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install -y -q postgresql-9.3 postgresql-contrib-9.3 libpq-dev sudo

RUN  DEBIAN_FRONTEND=noninteractive apt-get install -y -q postgresql-9.3 postgresql-contrib-9.3 libpq-dev 

# /etc/ssl/private can't be accessed from within container for some reason
# (@andrewgodwin says it's something AUFS related)
RUN mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R postgres /etc/ssl/private

ADD postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

VOLUME ["/var/lib/postgresql"]
EXPOSE 5432

CMD /usr/sbin/sshd -D && /usr/local/bin/run

