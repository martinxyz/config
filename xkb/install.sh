#!/bin/bash
set -e
echo "No longer using this! Directly program the keyboard instead."
exit 1

if ! grep 'xkb_symbols "maxy"' /usr/share/X11/xkb/symbols/ch; then
    cp /usr/share/X11/xkb/symbols/ch symbols/ch.system
fi

sudo cp symbols/ch /usr/share/X11/xkb/symbols/ch
sudo rm -f /var/lib/xkb/*.kkm  # was empty in my system, but just in case

if ! grep "<name>maxy</name>" /usr/share/X11/xkb/rules/evdev.xml > /dev/null; then 

  echo "Okay, but must edit /usr/share/X11/xkb/rules/evdev.xml manually:"
  cat <<EOF
         <name>ch</name>
         <!-- Keyboard indicator for German layouts -->
         <shortDescription>de</shortDescription>
         <description>German (Switzerland)</description>
         <languageList>
           <iso639Id>deu</iso639Id>
           <iso639Id>gsw</iso639Id>
         </languageList>
       </configItem>
       <variantList>
         <variant>
+           <configItem>
+             <name>maxy</name>
+             <description>German (Switzerland, Maxy)</description>
+          </configItem>
+        </variant>
+        <variant>
           <configItem>
             <name>legacy</name>
             <description>German (Switzerland, legacy)</description>
           </configItem>
         </variant>
EOF
else
  echo "Okay, installed."
fi

