LANG="en_GB.UTF-8"
LANGUAGE="en_GB.UTF-8"
LC_ALL="en_GB.UTF-8"
HOME_MANAGER_SCRIPT="/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"

if [[ -f $HOME_MANAGER_SCRIPT ]]; then
    source $HOME_MANAGER_SCRIPT
fi
