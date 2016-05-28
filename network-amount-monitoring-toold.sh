#!/bin/sh


monitoring_daemon (){
    clockworkd -c network-monitor.rb start --log
}


monitoring_daemon



