#!/bin/sh


monitoring (){
    clockwork clock.rb
}

monitoring_daemon (){
    clockworkd -c clock.rb start
}


monitoring_daemon

