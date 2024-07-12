# homelab
To run the ansible commands from a VScode terminal window you need to run: sudo apt install language-pack-en

```cmd
git config --global user.name "silentijsje"
git config --global user.email github@silentijsje.com
```

cron jobs
```
# 30 3 * * * /home/gamer0308/github/homelab_pub/gitCodeBak.sh
* * * * * ~/github/homelab_pub/scripts/fetchgit.sh
```

useradd -m -s /bin/bash -G sudo gamer0308
passwd gamer0308

ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519 -C stanley-PC-WSL -q

qm set 330 -scsi1 /dev/disk/by-id/ata-INTEL_SSDSC2KB019T8_PHYF911400AC1P9DGN
qm set 330 -scsi2 /dev/disk/by-id/ata-INTEL_SSDSC2KB019T8_PHYF911503RL1P9DGN