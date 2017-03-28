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
    - if [ -e /etc/ironic/ironic.conf  ]; then  mv /etc/ironic/ironic.conf /etc/ironic/ironic.conf.sample ; fi
  - require:
    - pkg: ironic_packages

{# in upstream Ubuntu Xenial repos, python-ironic package already depends on python-pymysql #}
{# TODO(pas-ha) refine the suitable OS selection #}
{%- if grains.osfinger != 'Ubuntu-16.04' %}
ironic_python_packages:
  pip.installed:
  - name: pymysql
  - upgrade: True
  - watch:
    - ironic_packages
{%- endif %}

/etc/ironic/ironic.conf:
  file.managed:
  - source: salt://ironic/files/{{ server.version }}/ironic.conf.{{ grains.os_family }}
  - template: jinja
  - require:
    - cmd: ironic_keep_sample_cfg

ironic_install_database:
  cmd.run:
  - names:
    - ironic-dbsync --config-file /etc/ironic/ironic.conf upgrade
  - require:
    - file: /etc/ironic/ironic.conf

ironic-api:
  service.running:
    - enable: true
    - full_restart: true
    - watch:
      - file: /etc/ironic/ironic.conf

ironic-conductor:
  service.running:
    - enable: true
    - full_restart: true
    - watch:
      - file: /etc/ironic/ironic.conf


{%- endif %}
