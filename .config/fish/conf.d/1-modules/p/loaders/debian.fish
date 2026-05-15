#!/usr/bin/env fish
function p_detect
    # https://unix.stackexchange.com/a/671133
    if string match -e --quiet -- Debian (grep -oPm1 "NAME=[\"']?\K.[^\"']+" /etc/os-release)
        return 0
    end

    return 127
end

function p_setup
    if command -q nala
        abbr --position anywhere p "sudo nala"
        abbr par "sudo nala autoremove -y"
        abbr pc "sudo nala clean"
        abbr pi "sudo nala install -y"
        abbr pq "dpkg -s"
        abbr pri "sudo apt-get reinstall -y"
        abbr prm "sudo nala remove -y"
        abbr psr "nala search"
        abbr psu "sudo nala full-upgrade -y"
        abbr pupd "sudo nala update"
        abbr pupg "sudo nala upgrade -y"
    else if command -q apt-get
        abbr --position anywhere p "sudo apt-get"
        abbr par "sudo apt-get autoremove -y"
        abbr pc "sudo apt clean"
        abbr pi "sudo apt-get install -y"
        abbr pq "dpkg -s"
        abbr pri "sudo apt-get reinstall -y"
        abbr prm "sudo apt-get remove -y"
        abbr psr "apt search"
        abbr psu "sudo apt-get full-upgrade -y"
        abbr pupd "sudo apt-get update"
        abbr pupg "sudo apt-get upgrade -y"
    else
        return 127
    end

    return 0
end

function p_teardown
    abbr --erase p par pc pi pq pri prm psr psu pupd pupg

    return 0
end
