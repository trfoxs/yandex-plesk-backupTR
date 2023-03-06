#!/bin/bash
##
# Name: Plesk Yandex haftalık güncelleme
# Author: foxtr
# Update: foxtr
# Version: 1.0.1
# Description: Yandex sync plesk yedekleme

if [ $(which yandex-disk) ]; then
clear
echo -e "
######  ####  #    # ##### #####  
#      #    #  #  #    #   #    # 
#####  #    #   ##     #   #    # 
#      #    #   ##     #   #####  
#      #    #  #  #    #   #   #  
#       ####  #    #   #   #    #

[TR] Yandex Disk Plesk Yedekleme
[RU] Резервное копирование Plesk на Яндекс Диске
[DE] Yandex Disk Plesk-Sicherung
"
	echo -e "[\e[31mOK\e[39m] Yandex-disk tespit edildi !"
	echo -e "[\e[93mDOING\e[39m] Lütfen yandex yedekleme ana dizini belirtiniz, örn.: /var/home/plesk-backup: "
	read -p "Dizin Adı: " foldername
	echo -e "[\e[93mDOING\e[39m] Dizin kontrol ediliyor, $foldername..."
	
	# folder check
	if [ -d "$foldername" ]; then 
		echo -e "[\e[31mOK\e[39m] $foldername dizini oluşturulmuş"
	
		# create plesk cron.weekly
		if [ $(which plesk version) ]; then 
			echo -e "[\e[31mOK\e[39m] Plesk kurulmuş"
			echo -e "[\e[93mDOING\e[39m] Plesk otomatik yedekleme cron.weekly oluşturuluyor..."
			rm -f /etc/cron.weekly/plesk-yandex-backup
			touch /etc/cron.weekly/plesk-yandex-backup

echo "\
#!/bin/bash
##
# Name: Plesk Yandex haftalık güncelleme
# Author: foxtr
# Update: foxtr
# Version: 1.0.1
# Description: Yandex sync plesk yedekleme

SYNC_DIR=$foldername/plesk-backup
DATE="'`date +%d-%m-%Y-%H%i%s`'"

if [ "'$(which yandex-disk)'" ]; then 
[ -d "'$SYNC_DIR'" ] || mkdir "'$SYNC_DIR'"
/usr/local/psa/bin/pleskbackup server --incremental --description=\"Sunucu artırımlı yedekleme\" --output-file=\""'$SYNC_DIR'"/server-incremental-backup-"'$DATE'".tar\"
yandex-disk sync
exit 0
else
exit 1
fi"\ > /etc/cron.weekly/plesk-yandex-backup

			chmod +x /etc/cron.weekly/plesk-yandex-backup
			
			sleep 5
			echo -e "[\e[31mOK\e[39m] Plesk otomatik yedekleme cron.weekly oluşturma başarıkı."
			echo -e "\n tadını çıkarın :) "
			
		else 
			echo -e "[\e[31mFAIL\e[39m] Plesk kurulu değil, tekrar deneyin."
			echo -e "[\e[31mOK\e[39m] Program kapatılıyor :(."
			exit 1
		fi
		
	else
		echo -e "[\e[31mFAIL\e[39m] Lütfen dizinin var olduğundan emin olun ve tekrar deneyin."
		echo -e "[\e[31mOK\e[39m] Program kapatılıyor :(."
		exit 1
	fi

fi