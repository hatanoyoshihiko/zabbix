# How to deploy zabbix using ansible

## Clone Repository

`# cd /etc/ansible`
`# git clone https://github.com/hatanoyoshihiko/zabbix.git`
`# mv zabbix/ansible/* /etc/ansible/`

## Configure inventory file

`# vi /etc/ansible/inventory/inventory.ini`

```ini
[zabbix_server]
zabbix01 ansible_host=172.20.55.190
```

## Run playbook

`# cd /etc/ansible`
`# ansible-playbook -i inventory/inventory.ini -k`

## Initial zabbix setting

Access to zabbix URL to be appered end of playbook.
