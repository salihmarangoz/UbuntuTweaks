<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->



<!-- END doctoc generated TOC please keep comment here to allow auto update -->

################# FREE SPACE ########################

baobab
flatpak uninstall --unused
pip cache purge
~/.cache/vmware/drag_and_drop
~/.cache/thumbnails/large
sudo journalctl --vacuum-time=1d


Check the folder size of 
/home/$USER/.local/share/Trash
There may be files that user can't delete without sudo



--------------------------



FREE SOME SPACE

# src: https://askubuntu.com/questions/1036633/how-to-remove-disabled-unused-snap-packages-with-a-single-line-of-command

LANG=C snap list --all | while read snapname ver rev trk pub notes; do if [[ $notes = *disabled* ]]; then sudo snap remove "$snapname" --revision="$rev"; fi; done

sudo snap set system refresh.retain=2


sudo du -sh /var/lib/snapd/cache/                  # Get used space
sudo find /var/lib/snapd/cache/ -exec rm -v {} \;  # Remove cache

-----------------

sudo apt remove lib*-doc

flatpak uninstall --unused --delete-data

sudo systemctl disable atop.service
sudo systemctl stop atop.service
# afterward delete atop logs

# remove unused nsight packages
sudo apt remove nsight-compute-xxxxxx

# wow slow
docker system prune --all --volumes

sudo apt remove texlive-*-doc
sudo apt-get --purge remove tex.\*-doc$

# also delete "/usr/share/doc/texlive-doc"