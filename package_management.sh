#!/bin/bash

count_installed_packages() {
    count=$(pacman -Qq | wc -l)
    echo ""
    echo "Total installed packages: $count"
    read -p "Press any key to continue"
}

backup_installed_packages() {
    pacman -Qqe > pkglist
    echo "Installed packages list backed up to 'pkglist'"
    read -p "Press any key to continue"
}

install_packages_from_file() {
    if [ -f "$1" ]; then
		echo "Packages read from '$1'"
		read -p "Are you sure you want to install from '$1'? [y/N]" answ
		if [ "$answ" == "y" ]; then
			sudo pacman -S --needed - < "$1"
			read -p "Installation complete! Press any key to continue."
		else	
			read -p "Aborting. Press any key to return to menu."
		fi
    else
        echo "File not found: $1"
        read -p "Press any key to continue"
    fi
}

show_menu() {
	clear
    echo "===== Package Management Menu ====="
    echo "1. Count Installed Packages"
    echo "2. Backup Installed Packages"
    echo "3. Install Packages from File"
    echo "4. Exit"
    echo "==================================="

    read -p "Enter your choice (1-4): " choice

    case $choice in
        1) count_installed_packages ;;
        2) backup_installed_packages ;;
        3) read -p "Enter the file name with package list: " file_name
           install_packages_from_file "$file_name" ;;
        4) echo "Exiting the script. Goodbye, $USER!"; exit ;;
        *) echo "Invalid choice. Please enter a number between 1 and 4."
    esac
}

# Check for command-line arguments
if [ "$#" -eq 0 ]; then
    while true; do
        show_menu
    done
else
    case $1 in
        -c) count_installed_packages ;;
        -b) backup_installed_packages ;;
        -i) if [ -n "$2" ]; then
                install_packages_from_file "$2"
            else
                echo "Please provide a file name with the package list."
            fi ;;
        *) echo "Invalid option. Usage: $0 [-c | -b | -i <file_name>]"
    esac
fi
