#!/bin/bash
set -uo pipefail

# Based on: http://www.richud.com/wiki/Ubuntu_Fluxbox_GUI_with_x11vnc_and_Xvfb

readonly G_LOG_I='[INFO]'
readonly G_LOG_W='[WARN]'
readonly G_LOG_E='[ERROR]'

main() {
    launch_xvfb
    launch_window_manager
    launch_pulseaudio
    run_vnc_server
    run_novnc_server
    get_zoomauth
    run_nginx
}

launch_xvfb() {
    # Set defaults if the user did not specify envs.
    export DISPLAY=${XVFB_DISPLAY:-:1}
    local screen=${XVFB_SCREEN:-0}
    local resolution=${XVFB_RESOLUTION:-1280x720x16}
    local timeout=${XVFB_TIMEOUT:-5}
    
    # Start and wait for either Xvfb to be fully up or we hit the timeout.
    Xvfb ${DISPLAY} -screen ${screen} ${resolution} &
    local loopCount=0
    until xdpyinfo -display ${DISPLAY} > /dev/null 2>&1
    do
        loopCount=$((loopCount+1))
        sleep 1
        if [ ${loopCount} -gt ${timeout} ]
        then
            echo "${G_LOG_E} xvfb failed to start."
            exit 1
        fi
    done
}

launch_window_manager() {
    local timeout=${XVFB_TIMEOUT:-5}
    
    # Start and wait for either fluxbox to be fully up or we hit the timeout.
    openbox &
    local loopCount=0
    until wmctrl -m > /dev/null 2>&1
    do
        loopCount=$((loopCount+1))
        sleep 1
        if [ ${loopCount} -gt ${timeout} ]
        then
            echo "${G_LOG_E} fluxbox failed to start."
            exit 1
        fi
    done
}

run_vnc_server() {
    local passwordArgument='-nopw'
    if [ ! -z "${VNC_SERVER_PASSWORD:-}" ]
    then
        local passwordFilePath="${HOME}/x11vnc.pass"
        if ! x11vnc -storepasswd "${VNC_SERVER_PASSWORD}" "${passwordFilePath}"
        then
            echo "${G_LOG_E} Failed to store x11vnc password."
            exit 1
        fi
        passwordArgument=-"-rfbauth ${passwordFilePath}"
        echo "${G_LOG_I} The VNC server will ask for a password."
    else
        echo "${G_LOG_W} The VNC server will NOT ask for a password."
    fi
    
    x11vnc -display ${DISPLAY} -noncache -forever ${passwordArgument} &
    # wait $!
}

launch_pulseaudio() {
    pulseaudio -D --exit-idle-time=-1
    pacmd load-module module-virtual-source
}

run_novnc_server() {
    /easy-novnc_linux-64bit -a ":${NOVNC_PORT:-6901}" ${EASY_NOVNC_ARGS:-''} &
}

get_zoomauth() {
    if [ ! -z "${ZOOMAUTH_URL:-}" ]
    then
        echo "Getting zoomauth"
        wget -qO /tmp/zoomauth.tar.gz --no-check-certificate ${ZOOMAUTH_URL} \
        && tar -xzf /tmp/zoomauth.tar.gz -C /home/apps/
    else
        echo "No Zoom Auth provided"
    fi
}

run_nginx() {
    envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf;
    echo "Substituted $PORT in nginx";
    nginx -g 'daemon off;'
}

control_c() {
    echo ""
    exit
}

trap control_c SIGINT SIGTERM SIGHUP

main

exit