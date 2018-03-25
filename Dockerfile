FROM alpine:latest
# 设置编码
ENV LANG en_US.utf8
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
RUN apk update 
RUN apk upgrade
# 安装openssh-server和sudo (命令连起来更省空间)
RUN apk add openssh sudo sshpass expect && \
sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \

ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \

apk add make automake autoconf libtool subversion git readline-dev mysql-client \
		net-tools vim gcc g++ libc-dev valgrind gdb py-pip lua5.3 python-dev lua5.3-dev mysql-dev &&\

echo 'export LANG="en_US.utf8"' >> /etc/profile && \

echo 'export LC_ALL="en_US.utf8"' >> /etc/profile

# copy expect script
COPY ./add_user.exp /bin/add_user.exp

RUN pip install --upgrade pip && pip install redis MySQL &&\
#RUN \
#add user
expect /bin/add_user.exp ligang ligang && \
echo "ligang   ALL=(ALL)       ALL" >> /etc/sudoers && \
mkdir /var/run/sshd 
EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
