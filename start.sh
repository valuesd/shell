#!/usr/bin/env bash
#
# Author: value
# Email: 925960983@qq.com
# Date: 2019/05/25
# Usage:system

# turn off firewalld and selinux.
systemctl disable firewalld &&  systemctl stop firewalld
STATUS=$(getenforce)
if [ $STATUS == "Disabled" ];then
  printf "SELINUX is closed.\n"
else
 sed -ri s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
  setenforce 0
fi


# init yumrepo and install always software tools.
 mkdir /etc/yum.repos.d/repobak
 mv /etc/yum.repos.d/* /etc/yum.repos.d/repobak/

 curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
if [ $? -ne 0 ];then
  printf "Please check your network!!!\n"
  exit
else
   curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
  if [ $? -ne 0 ];then
    printf "Please check your network!!!\n"
    exit
  else
     sed -rie '/aliyuncs*/d' /etc/yum.repos.d/CentOS-Base.repo
     yum clean all &&  yum makecache fast
  fi
fi

 yum -y install vim net-tools wget ntpdate ShellCheck cmake make lftp
 yum -y groupinstall "Development Tools"


# time upload rsync.
 ntpdate -b ntp1.aliyun.com

# sshd majorization.
 sed -ri s/"#UseDNS yes"/"UseDNS no"/g /etc/ssh/sshd_config
 systemctl restart sshd
