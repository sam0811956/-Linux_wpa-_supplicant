# 取出無線介面 
wifi="ip a |grep 'w' | cut -d ':' -f2" 

# 將設定寫入 /etc/network/interface
cat >> /etc/network/interface << "eof"
auto $wifi 
allow-hotplug $wifi 
iface $wifi inet manual
	wpa-roam /etc/wpa_supplicant/wpasupplicant.conf
iface default inet dhcp 
eof
