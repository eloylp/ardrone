
bin/wpa_passphrase `cat config.txt | head -n1` `cat config.txt | tail -n1` > wpa_supplicant.conf
killall udhcpd
ifconfig ath0 0.0.0.0
iwconfig ath0 essid `cat config.txt | head -n1`
bin/wpa_supplicant -B -Dwext -iath0 -cwpa_supplicant.conf
wait 5
/sbin/udhcpc -i ath0
