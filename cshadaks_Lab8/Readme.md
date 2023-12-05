# Iptables and Snort Configuration Script

## Overview

This script automates the configuration of iptables rules and sets up Snort, an intrusion detection system, on a Linux server. The script is designed to enhance network security by controlling incoming and outgoing traffic through iptables and applying custom Snort rules.

## Iptables Configuration

### 1. Check for iptables Installation

Checks if iptables is installed. If not, it installs iptables using the package manager (apt-get in this case).

### 2. User Input for Folder Name

Prompts the user to enter a folder name where iptables configurations will be stored.

### 3. Create a Folder

Creates a folder in `/root/` with the specified name.

### 4. Execute Iptables Commands

Applies iptables rules at different sections and saves the configurations in text files within the created folder.

### 5. Zip the Folder

Zips the folder containing iptables configurations for easy sharing or backup.

### 6. Move the Zip File

Moves the zip file to `/home/sadmin/` for convenient access.

### 7. Instructions for Remote Copy

Displays a command for the exouser to copy the configurations from the server.

## Snort Configuration

### 8. Check for Snort Installation

Checks if Snort is installed. If not, it installs Snort using the package manager.

### 9. User Input for Snort Rules

Prompts the user to enter a new name for Snort `.rules` files.

### 10. Create a Snort Rules File

Creates a new Snort `.rules` file with specified rules.

### 11. Open Snort Rules File with Vim

Opens the created Snort rules file with the Vim text editor.

### 12. Open Snort Configuration File with Vim

Opens the Snort configuration file `/etc/snort/snort.conf` with Vim.

### 13. Snort Restart

Restarts the Snort service to apply the new configurations.
