# OperaFFier
[Source](https://gitlab.com/Nesze/operaffier)
## This script can be used to patch Opera on Ubuntu based platforms, to make it able to play H.264 videos (eg. on Twitter)

### Executing this pach requires
- root permissions
- the *apt-get* command line tool

### The script can
- install the *chromium-ffmpeg-codecs-extra* package
- create a backup of *libffmpeg.so* in your Opera installation folder under */usr/lib/x86_64-linux-gnu/opera*
- restore a previous backup
- copy *libffmpeg.so* from */usr/lib/chromium-browser* to the Opera installation folder

### Known issues:
- In case the *chromium-codecs-ffmpeg-extra* installation finishes, but the patch fails, try removing the package (with *apt-get remove chromium-codecs-ffmpeg-extra*), and then run the script again to reinstall it.

I tried to be as careful as possible while writing the script, but please use it at your own risk.

### Changelog:

v1.0
- Initial version
