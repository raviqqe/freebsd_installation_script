while :
do
  xsetroot -name "`
      whoami
    `@`
      hostname -s
    ` | `
      uptime | grep -o 'load.*'
    ` | battery: `
      acpiconf -i 0 | grep 'Remaining capacity:' \
      | grep -o '[^[:blank:]]*$'
    ``
      if [ -z $(acpiconf -i 0 | grep 'State:' | grep -o discharging) ]
      then
        echo ', charging'
      fi
    ` | `
      TZ=Asia/Tokyo date | sed 's/  */ /g'
    `"
  sleep 0.3
done &

urxvt &
exec dwm
