# This script should NEVER be run without understanding what each line of it does. Theres NO recovery without a backup. This is mean to PURGE a box not "clean it up". It's not great code. Nobodies winning any awards for it. Use it at your own risk. I am NOT responsible for anything you do with this.


#!/bin/bash
SECONDS=0

printf "If you are seeing this message it may already be too late. Hit Ctrl-Z quick!"

#Check if running as root and if not elevate
amiroot=$(sudo -n uptime 2>&1| grep -c "load")
if [ "$amiroot" -eq 0 ]
then
    printf "Housekeeping Services Require Root Access. Please Enter Your Password.\n"
    sudo -v
    printf "\n"
fi

#Delete Saved SSIDs For Security
#Be Sure To Set Home And Work SSID for ease of use.
printf "Deleting saved wireless networks.\n"
homessid="WHATAMESH"
workssid=""
IFS=$'\n'
for ssid in $(networksetup -listpreferredwirelessnetworks en0 | grep -v "Preferred networks on en0:" | grep -v $homessid | grep -v $workssid | sed "s/[\	]//g")
do
    networksetup -removepreferredwirelessnetwork en0 "$ssid"  > /dev/null 2>&1
done

#Generate Random MAC Address.
printf "MAC for your Mac\n"
openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether

#DNS Cache flush.
printf "Domain Names? We don't need no stinking domain names\n"
sudo killall -HUP mDNSResponder

#Taking out the trash.
printf "Taking out the trash.\n"
sudo rm -rfv /Volumes/*/.Trashes > /dev/null 2>&1
sudo rm -rfv ~/.Trash  > /dev/null 2>&1

#Clean the logs.
printf "Washing the system log files.\n"
sudo rm -rfv /private/var/log/*  > /dev/null 2>&1
sudo rm -rfv /Library/Logs/DiagnosticReports/* > /dev/null 2>&1
sudo rm -rfv /Library/Logs/* > /dev/null 2>&1

#ONLY FOR THOSE WHO KNOW WHAT THEY ARE DOING
printf "Deep Cleaning"
sudo rm -rfv /Library/Saved Application State/* > /dev/null 2>&1
sudo rm -rfv /Library/Caches/* > /dev/null 2>&1
sudo rm -rfv /Library/Calendars/* > /dev/null 2>&1
sudo rm -rfv /Library/Messages/* > /dev/null 2>&1
sudo rm -rfv /Library/Messages/* > /dev/null 2>&1
sudo rm -rfv /Library/Cookies/* > /dev/null 2>&1
sudo rm -rfv /Library/Synced Preferences/* > /dev/null 2>&1
sudo rm -rfv /Library/Preferences/* > /dev/null 2>&1
sudo rm -rfv /Library/Synced Preferences/* > /dev/null 2>&1
sudo rm -rfv /Library/Saved Searches/* > /dev/null 2>&1
sudo rm -rfv /Library/Mail/* > /dev/null 2>&1
sudo rm -rfv /Library/Autosave Information/* > /dev/null 2>&1
sudo rm -rfv /Library/Keychains/* > /dev/null 2>&1
sudo rm -rfv /Library/Accounts/* > /dev/null 2>&1
sudo rm -rfv /Library/Group Containers/* > /dev/null 2>&1
sudo rm -rfv /Library/PersonalizationPortrait/* > /dev/null 2>&1
sudo rm -rfv /Library/Homekit/* > /dev/null 2>&1
sudo rm -rfv /private/var/log/asl/* > /dev/null 2>&1
sudo rm -rfv /private/var/log/install.log > /dev/null 2>&1
sudo rm -rfv /Library/Preferences/SystemConfiguration/* > /dev/null 2>&1
sudo rm -rfv /tmp/* > /dev/null 2>&1
sudo rm -rfv /var/tmp/* > /dev/null 2>&1


printf "Purging ZSH History.\n"
sudo rm -f /Users/"$(whoami)"/.zsh_history > /dev/null 2>&1

printf "Purging ALL Downloads.\n"
sudo rm -f /Users/"$(whoami)"/Downloads/* > /dev/null 2>&1

printf "Purging user specific settings (some may not apply to you)"
sudo rm -rfv /Users/"$(whoami)"/.wireshark/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.tor/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whomai)"/.zsh_history > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.DDPreview > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/electrum/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.bash_profile > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.kube/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.oh-my-zsh/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.ghidra/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.proxyman/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.zenmap/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.config/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.bash_history > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.ssh/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.cache/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.gitkraken/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.reincubate/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.BurpSuite/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.shodan/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.3T/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/.local/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/Library/Internet Plug-Ins/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/Library/Application Support/Firefox/Profiles/* > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/Library/Application SupportGoogle/Chrome/Default/*  > /dev/null 2>&1
sudo rm -rfv /Users/"$(whoami)"/Library/Application SupportGoogle/Chrome/Default/*  > /dev/null 2>&1

printf "Cleaning the quicklook files.\n"
sudo rm -rf /private/var/folders/ > /dev/null 2>&1

#Removing Known SSH Hosts (This is optional if you don't use deep clean)
printf "Removing known ssh hosts.\n"
sudo rm -f /Users/"$(whoami)"/.ssh/known_hosts > /dev/null 2>&1

#Securly Erasing Data.
printf "Safing up freespace (This will take a while). \n"
diskutil secureErase freespace 0 "$( df -h / | tail -n 1 | awk '{print $1}')" > /dev/null 2>&1

#Cleaning Up Docker.
#You May Not Want To Do This.
printf "Removing all Docker containers.\n"
docker rmi -f "$(docker images -q --filter 'dangling=true')" > /dev/null 2>&1

#Purging Memory.
printf "Purging memory.\n"
sudo purge > /dev/null 2>&1

#Removing Known SSH Hosts (This is optional if you don't use deep clean)
printf "Removing known ssh hosts.\n"
sudo rm -f /Users/"$(whoami)"/.ssh/known_hosts > /dev/null 2>&1

#Securly Erasing Data.
printf "Safing up freespace (This will take a while). \n"
diskutil secureErase freespace 0 "$( df -h / | tail -n 1 | awk '{print $1}')" > /dev/null 2>&1

#Install Updates.
 printf "Installing needed updates.\n"
 softwareupdate -i -a > /dev/null 2>&1

#Cleaning Up Ruby.
printf "Cleaning Up Ruby.\n"
gem cleanup > /dev/null 2>&1

#Cleaning Up Homebrew.
printf "Cleaning up Homebrew.\n"
brew cleanup --force -s > /dev/null 2>&1
brew cask cleanup > /dev/null 2>&1
rm -rfv /Library/Caches/Homebrew/* > /dev/null 2>&1
brew tap --repair > /dev/null 2>&1
brew update > /dev/null 2>&1
brew upgrade > /dev/null 2>&1

#Purging Memory.
printf "Purging memory.\n"
sudo purge > /dev/null 2>&1

#Securly Erasing Data.
printf "Safing up freespace (This will take a while). \n"
diskutil secureErase freespace 0 "$( df -h / | tail -n 1 | awk '{print $1}')" > /dev/null 2>&1

#Finishing Up.
timed="$((SECONDS / 3600)) Hours $(((SECONDS / 60) % 60)) Minutes $((SECONDS % 60)) seconds"

printf "Housekeeping Took %s this time. Dont Forget To Tip!\n" "$timed"
