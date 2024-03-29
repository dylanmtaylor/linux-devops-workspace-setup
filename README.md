# Workspace configuration script

This script configures an Ubuntu-based AWS WorkSpace with various software packages and customizations that I enjoy. This is for my personal use but feel free to steal/adapt this to your liking. The script is provided as-is, with no guarantees for correctness or best-practices/security (some of the Docker workarounds are not super great, security-wise).

## Functions

The script performs the following functions:

* Updates the system and installs necessary packages for further steps to succeed.
* Installs and configures Docker in a way that works with domain users and AWS workspaces networking.
    * This was actually particularly challenging to figure out, because with an AD-joined user it's not set up like a local account.
* Installs Google Chrome, Microsoft Edge, and Visual Studio Code from their respective stable repositories.
* Replaces Firefox and LibreOffice with their Flatpak versions. This is because:
    * Snaps are terrible compared to Flatpak and native packages from a performance standpoint.
    * I like having up to date software and don't care to be stuck with an LTS release.
* Installs Podman and registry configuration for that. Podman has proven to be a bit finicky on WorkSpaces, but it mostly works.
* Installs and configures Nix and home-manager using Fleek for declarative package/home management
* Writes a copy of my `.fleek.yaml` file and runs `fleek apply` to evaluate and apply it.
* Installs a handful of GNOME Extensions I like to have:
    * Dash to Panel
    * Alphabetical App Grid
    * Arc Menu
* Installs numerous GUI applications via flatpak by iterating over the lines of the installed_packages.txt file.
* Alphabetizes the app grid.
