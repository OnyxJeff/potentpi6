
#!/bin/bash
set -euo pipefail

BASE_DIR="/usr/local/dashpi"
CONFIG_DIR="$BASE_DIR/config"

URL_FILE="$CONFIG_DIR/url.txt"
CHECK_INTERVAL=5

get_url() {
    [[ -f "$URL_FILE" ]] && cat "$URL_FILE" || echo "https://example.com"
}

launch_browser() {
    local URL
    URL=$(get_url)

    echo "Launching Chromium with URL: $URL"

    chromium \
        --kiosk "$URL" \
        --start-fullscreen \
        --noerrdialogs \
        --disable-session-crashed-bubble \
        --disable-infobars \
        --disable-translate \
        --disable-features=TranslateUI \
        --incognito \
        --no-first-run \
        --check-for-update-interval=31536000 &
}

LAST_URL=""

# Hide mouse cursor
unclutter -idle 0 &

while true; do
    CURRENT_URL=$(get_url)

    # Restart Chromium if the URL changes
    if [[ "$CURRENT_URL" != "$LAST_URL" ]]; then
        echo "URL changed → restarting Chromium"
        pkill chromium || true
        launch_browser
        LAST_URL="$CURRENT_URL"
    fi

    # Restart Chromium if it crashes or closes
    if ! pgrep -x chromium >/dev/null; then
        echo "Chromium not running → restarting"
        launch_browser
    fi

    sleep "$CHECK_INTERVAL"
done
