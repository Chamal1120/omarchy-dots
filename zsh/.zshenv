# Read by every zsh, interactive or not (the counterpart of the env part of ~/.bashrc).

# Omarchy environment (OMARCHY_PATH + PATH). The file is plain POSIX sh.
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# Flutter (stable SDK in ~/development/flutter) and the Android SDK from Android Studio
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$HOME/development/flutter/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
