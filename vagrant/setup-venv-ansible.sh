#!/bin/sh

apt-get install -y python3-venv python3-pip
python3 -m venv /opt/ansible

# shellcheck source=/dev/null
. /opt/ansible/bin/activate
pip install ansible
deactivate

cat <<EOF > /etc/profile.d/ansible.sh
#!/bin/bash

export PATH=/opt/ansible/bin:$PATH

EOF

