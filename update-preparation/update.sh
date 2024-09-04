set -x 
chmod +x /useremain/update_swu/update-logged.sh
/useremain/update_swu/update-logged.sh  > /useremain/update_swu/update-result.txt 2>&1
grep -qxF 'sleep 20' /userdata/app/gk/start.sh || echo 'sleep 20' >> /userdata/app/gk/start.sh
grep -qxF '/useremain/openssh/sshd_start.sh' /userdata/app/gk/start.sh || echo '/useremain/openssh/sshd_start.sh' >> /userdata/app/gk/start.sh
grep -qxF 'curl --data-binary "@/useremain/update_swu/update-result.txt" 192.168.1.245/printer' /userdata/app/gk/start.sh || echo 'curl --data-binary "@/useremain/update_swu/update-result.txt" 192.168.1.245/printer' >> /userdata/app/gk/start.sh
