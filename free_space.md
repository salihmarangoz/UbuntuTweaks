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