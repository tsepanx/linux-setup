#!/bin/bash

DIR_1="/media/st/torrent/.incomplete"
DIR_2="/media/st/torrent/"
SETTINGS_PATH="/etc/transmission-daemon/settings.json"
CONFIG_PATH="/etc/init.d/transmission-daemon"
SERVICE_PATH="/etc/systemd/system/multi-user.target.wants/transmission-daemon.service"

USER="debian-transmission"

RPC_USER="pi"
RPC_PASS="12345"
RPC_WHITELIST="*"

sudo apt install -y transmission-daemon moreutils
sudo systemctl stop transmission-daemon

sudo mkdir -p $DIR_1
sudo mkdir -p $DIR_2

sudo chown -R $USER:$USER $DIR_1
sudo chown -R $USER:$USER $DIR_2

TMP_FILE="tmp.json"

sudo /bin/rm $TMP_FILE
sudo /bin/cp $SETTINGS_PATH $TMP_FILE

sudo jq                         '.["incomplete-dir-enabled"] = true'    $TMP_FILE | sponge $TMP_FILE
sudo jq --arg ARG "$DIR_1"      '.["incomplete-dir"] = $ARG'            $TMP_FILE | sponge $TMP_FILE
sudo jq --arg ARG "$DIR_2"      '.["download-dir"] = $ARG'              $TMP_FILE | sponge $TMP_FILE
sudo jq --arg ARG "$RPC_USER"   '.["rpc-username"] = $ARG'              $TMP_FILE | sponge $TMP_FILE
sudo jq --arg ARG "$RPC_PASS"   '.["rpc-password"] = $ARG'              $TMP_FILE | sponge $TMP_FILE
sudo jq --arg ARG "*"           '.["rpc-whitelist"] = $ARG'             $TMP_FILE | sponge $TMP_FILE

echo "=== RESULT CONFIG ==="
cat $TMP_FILE
echo "====================="

ask() {
    rstr="[y/<blank> = yes] "
    echo -en "$2 $rstr"
    read -n 1 ask </dev/tty
    echo

    if [[ -z $ask || $ask == 'y' ]]; then
        $1
    fi
}

write() {
    echo "Writing $SETTINGS_PATH..."
    sudo /bin/mv $TMP_FILE $SETTINGS_PATH
}

ask write "Write?"

# ========================================================

sudo sed -i "s/\(USER=\).*/\1$USER/" $CONFIG_PATH
sudo sed -i "s/\(user=\).*/\1$USER/" $SERVICE_PATH

sudo systemctl daemon-reload

sudo chown -R $USER:$USER /etc/transmission-daemon

start() {
    echo "Staring service..."
    sudo systemctl start transmission-daemon
}

ask start "Start service?"
