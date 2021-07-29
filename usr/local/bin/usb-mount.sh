#!/usr/bin/env bash

ACTION=$1
DEVBASE=$2
DEVICE="/dev/${DEVBASE}"

MOUNT_USER=egrep
MOUNT_GROUP=egrep

MOUNT_UID=1000
MOUNT_GID=1000

# See if this drive is already mounted
MOUNT_POINT=$(/bin/mount | /bin/grep ${DEVICE} | /usr/bin/awk '{ print $3 }')

do_mount()
{
    if [[ -n ${MOUNT_POINT} ]]; then
        # Already mounted, exit
        exit 1
    fi
	
    # Get info for this drive: $ID_FS_LABEL, $ID_FS_UUID, and $ID_FS_TYPE
    eval $(/sbin/blkid -o udev ${DEVICE})

    # Figure out a mount point to use
    LABEL=${ID_FS_LABEL}
    if [[ -z "${LABEL}" ]]; then
        LABEL=${DEVBASE}
    elif /bin/grep -q " /media/${LABEL} " /etc/mtab; then
        # Already in use, make a unique one
        LABEL+="-${DEVBASE}"
    fi
    MOUNT_POINT="/media/${LABEL}"

    /bin/mkdir -p ${MOUNT_POINT}
    /bin/chown ${MOUNT_USER}:${MOUNT_GROUP} ${MOUNT_POINT}

    # Global mount options
    OPTS="rw,users"

    # File system type specific mount options
    if [[ ${ID_FS_TYPE} == "vfat" ]]; then
        OPTS+=",user,relatime,uid=${MOUNT_UID},gid=${MOUNT_GID}"
	OPTS+=",shortname=mixed,utf8=1,flush"
    elif [[ ${ID_FS_TYPE} == "exfat" ]]; then
        OPTS+=",user,relatime,uid=${MOUNT_UID},gid=${MOUNT_GID}"
	OPTS+=",iocharset=utf8"
    elif [[ ${ID_FS_TYPE} == "ext4" ]]; then
        OPTS+=",defaults,errors=remount-ro"
    fi

    if ! /bin/mount -o ${OPTS} ${DEVICE} ${MOUNT_POINT}; then
        # Error during mount process: cleanup mountpoint
        /bin/rmdir ${MOUNT_POINT}
        exit 1
    fi

    if [[ ${ID_FS_TYPE} == "ext4" ]]; then
        /bin/chown ${MOUNT_USER}:${MOUNT_GROUP} ${MOUNT_POINT}
    fi
}

do_unmount()
{
    if [[ -n ${MOUNT_POINT} ]]; then
        /bin/umount -l ${DEVICE} || exit 1
    fi

    # Delete all empty dirs in /media that aren't being used as mount points. 
    for f in /media/* ; do
        if [[ -n $(/usr/bin/find "$f" -maxdepth 0 -type d -empty) ]]; then
            if ! /bin/grep -q " $f " /etc/mtab; then
                /bin/rmdir "$f"
            fi
        fi
    done
}

case "${ACTION}" in
    add)
        do_mount
        ;;
    remove)
        do_unmount
        ;;
esac
