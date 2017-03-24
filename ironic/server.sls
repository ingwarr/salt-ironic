{%- from "ironic/map.jinja" import server with context %}
{%- if server.enabled %}

ironic_packages:
  pkg.installed:
  - names: {{ server.pkgs }}
  - requre:
    - mysql

ironic_keep_sample_cfg:
  cmd.run:
  - names:
    - mv /etc/ironic/ironic.conf /etc/ironic/ironic.conf.sample
  - require:
    - pkg: ironic_packages 
    
# pip_upgrade:
#   pip.installed:
#   - name: pip
#   - upgrade: True
#   - watch:
#     - ironic_packages
 
# ironic_python_packages:
#   pip.installed:
#   - name: pymysql
#   - upgrade: True
#   - watch:
#     - pip_upgrade

/etc/ironic/ironic.conf:
  file.managed:
  - source: salt://ironic/files/{{ server.version }}/ironic.conf.{{ grains.os_family }}
  - template: jinja
  - require:
    - cmd: ironic_keep_sample_cfg:
 

ironic_install_database:
  cmd.run:
  - names:
    - ironic-dbsync --config-file /etc/ironic/ironic.conf upgrade
  - require:
    - file: /etc/ironic/ironic.conf

{%- endif %}
