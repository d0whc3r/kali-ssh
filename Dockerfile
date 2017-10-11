FROM kalilinux/kali-linux-docker
RUN apt-get update \
  && apt-get upgrade -yq \
  && apt-get install -yq aptitude git make gcc cpp binutils bash-completion
RUN apt-get install -yq openssh-server
RUN apt-get install -yq metasploit-framework sqlmap

RUN mkdir /var/run/sshd

COPY authorized_keys /root/.ssh/authorized_keys
COPY utils/apt.sh /root/bin/apt.sh

RUN chmod +x /root/bin/*.sh

RUN echo 'export PATH=/root/bin:$PATH' >> /root/.bashrc
# SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

CMD ["/usr/sbin/sshd", "-D"]
