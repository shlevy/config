#!@bash@/bin/bash
export PATH=@emacs@/bin:@firefox@/bin:@pass@/bin:@notmuch@/bin:@movemail@/bin:@mailloop@/bin:@gnupg@/bin:@isync@/bin:@msmtp@/bin:@git@/bin:$PATH
export PASSWORD_STORE_DIR="/home-persistent/shlevy/creds/password-store/"
export GNUPGHOME="/home-persistent/shlevy/creds/gnupg"
@xhost@/bin/xhost +SI:localuser:$USER
xrdb -merge $HOME/config/Xresources
xrandr --output eDP1 --fbmm 292x165
export GDK_SCALE=0.8
export GDK_DPI_SCALE=0.8
exec emacs
