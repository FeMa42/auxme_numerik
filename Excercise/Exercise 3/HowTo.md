# How to Install OpenManipulator

For a seamless OpenManipulator software installation, you can utilize the provided scripts. Please ensure you're operating on Ubuntu 20.04 and possess sudo rights, as the software is based on ROS Noetic.

## Prerequisites

- Ubuntu 20.04
- Sudo rights

If your system meets the prerequisites, follow the below steps in the specified order to install the necessary software:

```bash
sh ./install_ros_noetic.sh
```

```bash
sh ./install_openmanipulator_dependencies.sh
```

```bash
sh ./install_openmanipulator.sh
```

In case you encounter any issues executing these scripts, you may need to set them as executable first. This can be accomplished by running the following command in the directory where the scripts are located:

```bash
chmod +x ./install_ros_noetic.sh
chmod +x ./install_openmanipulator_dependencies.sh
chmod +x ./install_openmanipulator.sh
```

## Manual Installation

For those who prefer a more hands-on approach, a detailed guide for manual installation of the OpenManipulator software can be found here: [OpenManipulator Installation Guide](https://emanual.robotis.com/docs/en/platform/openmanipulator_x/quick_start_guide/#install-ubuntu-on-pc)

**Note:** Ensure to select 'Noetic' at the top of the guide to maintain compatibility with the scripts provided in this tutorial.