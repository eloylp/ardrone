
bin/wpa_passphrase `cat config.txt | head -n1` `cat config.txt | tail -n1` > wpa_supplicant.conf
killall udhcpd
ifconfig ath0 `cat fixed_ip.txt`
iwconfig ath0 essid `cat config.lst | head -n1`
bin/wpa_supplicant -B -Dwext -iath0 -cwpa_supplicant.conf
