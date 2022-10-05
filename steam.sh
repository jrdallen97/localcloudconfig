#!/usr/bin/env bash
LOCAL_PATH="$HOME/localcloudconfig/local_configs/$SteamAppId"
BACKUP_PATH="$HOME/localcloudconfig/backup_configs/$SteamAppId"
LOG_DIR="$HOME/localcloudconfig/log"
LOG_FILE="$LOG_DIR/$SteamAppId"

mkdir -p "$LOCAL_PATH"
mkdir -p "$BACKUP_PATH"
mkdir -p "$LOG_DIR"

echo "starting..." >"$LOG_FILE"

case "$SteamAppId" in
  292030)
    GAME_CONFIG_PATH="Documents/The Witcher 3"
    CONFIG_FILE="user.settings"
    ;;
  *)
    echo "unknown game: $SteamAppId" >>"$LOG_FILE"
    exit 1
    ;;
esac

# WIN_USER_PATH is the path used by proton to fake a Windows-like file structure?
WIN_USER_PATH="pfx/drive_c/users/steamuser"

# STEAM_COMPAT_DATA_PATH is set by Steam the location for the prefix used by the game
# default: ~/.local/share/Steam/steamapps/compatdata/$SteamAppId
# may be elsewhere depending on how you set up your steam library storage
GAME_CONFIG_FILE="$STEAM_COMPAT_DATA_PATH/$WIN_USER_PATH/$GAME_CONFIG_PATH/$CONFIG_FILE"

# Backup existing config before we do anything
if [[ -f "$GAME_CONFIG_FILE" ]]; then
  cp -v "$GAME_CONFIG_FILE" "$BACKUP_PATH/$CONFIG_FILE" >>"$LOG_FILE" 2>&1

  # If we don't already have a local version of the config, copy the existing file
  if [[ ! -f "$LOCAL_PATH/$CONFIG_FILE" ]]; then
    cp -v "$GAME_CONFIG_FILE" "$LOCAL_PATH/$CONFIG_FILE" >>"$LOG_FILE" 2>&1
  fi
fi

# Copy our local config into place
if [[ ! -f "$LOCAL_PATH/$CONFIG_FILE" ]]; then
  cp -v "$LOCAL_PATH/$CONFIG_FILE" "$GAME_CONFIG_FILE" >>"$LOG_FILE" 2>&1
fi

# Run the game!
echo "starting game" >>"$LOG_FILE"
"$@"
echo "exiting game" >>"$LOG_FILE"

# Copy the file back to our local directory
cp -v "$GAME_CONFIG_FILE" "$LOCAL_PATH/$CONFIG_FILE" >>"$LOG_FILE" 2>&1

# Restore the original config file & prevent steam from syncing our changes
cp -v "$BACKUP_PATH/$CONFIG_FILE" "$GAME_CONFIG_FILE" >>"$LOG_FILE" 2>&1
