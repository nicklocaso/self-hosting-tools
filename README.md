# Self-Hosting Tools

Self-Hosting Tools is a collection of scripts and tools aimed at simplifying the management and maintenance of self-hosted servers. This project is geared towards individuals and organizations that prefer to self-host their applications and services, rather than relying on third-party hosting providers.

The scripts included in this repository are designed to automate common system administration tasks such as automatic mounting and unmounting of partitions, automatic updates, and log management via email notifications.

## Getting Started

To use these scripts, simply clone the repository to your server using the following command:

```bash
git clone https://github.com/your-username/self-hosting-tools.git
```

Once cloned, navigate to the directory of the desired script and run it using the appropriate command.

## Installation

To install bash/\*.sh scripts, follow these steps:

1.  Copy the scripts to the `/usr/local/bin` directory:

    ```bash
    sudo cp bash/auto-mount.sh /usr/local/bin/auto-mount
    ```

2.  Make the scripts executable:

    ```bash
    sudo chmod +x /usr/local/bin/auto-mount
    ```

Now you can run the scripts from anywhere on your system by simply typing their name.

## Available Scripts

- bash/auto-mount.sh: Automates the mounting of specified partitions at boot time.
- bash/auto-umount.sh: Automates the unmounting of specified partitions and removes corresponding entries in /etc/fstab.

## Contributing

Contributions to this project are welcome and encouraged. If you have an idea for a new script or feature, please feel free to open an issue or submit a pull request.
