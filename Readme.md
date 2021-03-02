# wpa_supplicant 無線網路連線
##  wpa_supplicant
wpa_supplicant 可以用在 Linux 、 BSD、 MAC OS X、 Windows、 嵌入式系統..等的無線網路連線。
## 開發環境
* Linux Release: Debian Buster 64 bits
* Kernal Version: 4.19.0-12-amd64
# Step1 檢查 wifi 網卡有無啟用
```
$ sudo dmesg |grep -i wifi
```
如果沒有印出任何內容時,可能沒有裝到 wifi 的套件
將 wifi firmware套件裝上

```
$ sudo apt-get update && apt-get install firmware-iwlwifi
```


有啟用的話再來我們再檢查能否看見 wifi 名稱 

```
$ ip a 
```
有看到名稱為 wlp2s0 (Debian Buster 中的無線網路介面 )
如果沒有我們先執行這指令,讓無線網卡啟動
```
$ sudo ifup wlp2s0  
```
確認完有無線網路後再下一步
# Step2 安裝及設定 wpa_supplicant 
```
$ sudo apt install wpasupplicant  // Debian,Ubuntu
```
安裝完後編緝一個 wpa_supplicant.conf 檔，
將知道的無線網路名稱及密碼輸入至此檔
```
# 將 wpa.sh 放此
```

```  
$ sudo vi /etc/wpa_supplicant/wpa_supplicant.conf
```

```
ctrl_interface=/var/run/wpa_supplicant
update_config=1

network={
        ssid="你的SSID名稱，限英文" // 無線網路名稱
        psk="無線網路的密碼"  //無線網路密碼
}

```
# Step3 設定網路介面及自動連線無線網路
## 編緝 /etc/network/interfaces 
```
放入 interface.sh
```

    
``` 
$ sudo vi /etc/network/interfaces 
```
enp1s0、wlp2s0 為本文的有線網路及無線網路
依照偵測到的有線、無線網路介面來更改。

    source /etc/network/interfaces.d/*
    
    # loopback 
    auto lo
    iface lo inet loopback
    
    # DHCP 
    auto enp1s0
    allow-hotplug enp1s0  # enp1s0 為有線網路介面
    iface enp1s0 inet dhcp
    # wireless
    auto wlp2s0
    allow-hotplug wlp2s0  # wlp2s0 為無線網路介面
    iface wlp2s0 inet manual
        wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf  #自動連上在 wpa_supplicant.conf 的無線網路 //
    iface default inet dhcp

# 啟動 wpa_supplicant
```
// wlp2s0 是本文的無線網卡名稱，請讀者查看自已的無線網卡名稱
wpa_supplicant -B -i wlp2s0 -D nl80211 -c /etc/wpa_supplicant/wpa_supplicant.conf

```

# 參考文件
1. https://www.debian.org/doc/manuals/debian-reference/ch05.zh-tw.html#_the_wireless_lan_interface_with_wpa_wpa2
2. https://bigpxuan.blogspot.com/2016/12/wpasupplicant.html
3. https://newtoypia.blogspot.com/2014/09/wireless.html
