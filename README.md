# segue2 - Your own local galaxy of applications that work on the go.
## Description
Segue2 is a compact and efficient solution designed to enhance your home network and application ecosystem. Acting as a router, it seamlessly directs traffic from your modem (ISP) to your Wi-Fi mesh network, ensuring smooth connectivity. Beyond routing, Segue2 enables you to run micro-localized applications such as a Plex Media Server, VPN server, file server, and more, all from a single device. Built to operate on a Raspberry Pi, it delivers powerful functionality with minimal power consumption, making it an eco-friendly and versatile addition to your digital setup.
## Infrastructure
This being an entirely containerized service, you need to ensure that your host systems are properly configured. Open the admin dashboard and do the needful
    - See the internal ip address and open the port in your ISP's admin
    - Create your unique network name
    - Map the CNAME/Public ip (if you have a static public ip) to <unique-network-name>.segue2.com
    - Copy all your media to the predefined media folders. 
        - For plex you can only put information into following folders
            - tvshows
            - movies
            - welcome
        - For samba following folders are already created. You can add sub-folders.
            - videos
            - pictures
            - documents
    - For VPN
        - TBD
    - hardware specifications:
        - arch: arm64/raspberrypi5
        - system: raspberrypi5
        - OS: ubuntu 22.04
        - packages installed:
            - check ubuntu-app-list.txt. Remember to also install, git,avahi-daemon,docker and docker-compose
## License
Segue2 is licensed under the GNU General Public License v3.0. This license allows you to use, modify, and distribute the software, provided that any derivative works are also licensed under the same terms. It ensures end users retain the freedom to access and modify the source code while requiring proper attribution to the original authors.
## Features
- Easy setup and configuration.
- Supports multiple micro-localized applications.
- Low power consumption with Raspberry Pi compatibility.
- Acts as a router and application server simultaneously.

## Installation
1. Connect the Segue2 product to your modem and Wi-Fi mesh network.
2. Power on the device and follow the setup instructions.
3. Ensure that the environment variables are properly set. Below are a full list of environment variables that needs to be set up at the host system
    - HOST_USER_DATA
    - HOST_MEDIA_PATH
    - HOST_PLEX_VER
    - HOST_PLEX_ARCH
    - HOST_PLEX_DISTRO
    - HOST_SEGUE2_USER

## Usage
- Access the Segue2 dashboard via your browser.
- Configure routing and network settings.
- Install and manage applications like Plex, VPN, or file servers.
- You can do healthchecks on whether the apps are running or not by following manner:
    - Plex
        - docker ps
        - docker inspect --format='{{json .State.Health}}' segue2-lin2204-plex
        - docker logs segue2-lin2204-plex
- Once the plex server is running, it can be stopped and history and transcode data be migrated. This is advanced settings.

## Contributing
We welcome contributions! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a detailed description of your changes.

## Support
For issues or questions, please open an issue in the GitHub repository or contact us via email at support@segue2.com.

## Acknowledgments
- Inspired by open-source projects and the Raspberry Pi community.
- Special thanks to contributors and testers who made this project possible.