# Tree

sysadmin-utilities/
├── README.md
├── LICENSE
├── .gitignore
├── scripts/
│   ├── large_file_finder.sh
│   ├── sys_health_dashboard.py
│   ├── cron_backup.sh
│   ├── disk_cleanup.sh
│   └── user_report.sh
├── ansible/
│   └── vps_hardening.yml
├── docker/
│   └── uptime-kuma_setup.sh
├── docs/
│   └── usage_examples.md
├── config_samples/
│   ├── nginx_default.conf
│   └── sshd_config_hardened
└── utils/
    └── email_alert.py

## Readme
this is a repo for some common and useful system admin scripts. Its not complete yet, and neither is the documentation, but over time I will expand upon this repository and its usefulness will increase.

### Dependencies
None!

### Installation
fork the repo and sudo chmod +x to make the bash files executable and then run them with ./script_name.sh




