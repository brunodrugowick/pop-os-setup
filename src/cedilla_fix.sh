#!/bin/bash

## This tries to fix the cedilla for US keyboads. 
# The fix allows me to type the cedilla with <dead_acute> + <c> instead of <AltGr> + <,>

# NOTE: I do wanna test if by only adding the brazilian formats in the main config is enough

# Add US alongside PT for cedilla thing in all GTK versions present
sudo sed -e '/"cedilla"/ s|pt[:us]*:|pt:us:|g' -i /usr/lib/x86_64-linux-gnu/gtk-*/*/immodules.cache

# Replace all 'ć' and 'Ć' with 'ç' and 'Ç'
sudo cp /usr/share/X11/locale/en_US.UTF-8/Compose /usr/share/X11/locale/en_US.UTF-8/Compose.bak
sed 's/ć/ç/g' < /usr/share/X11/locale/en_US.UTF-8/Compose | sed 's/Ć/Ç/g' > Compose
sudo mv Compose /usr/share/X11/locale/en_US.UTF-8/Compose

# Write these things to /etc/environment
echo 'GTK_IM_MODULE=cedilla' | sudo tee -a /etc/environment
echo 'QT_IM_MODULE=cedilla' | sudo tee -a /etc/environment

