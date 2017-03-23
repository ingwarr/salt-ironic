{%- from "ironic/map.jinja" import server with context %}
{%- if server.enabled %}

ironic_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

/etc/ironic/ironic.conf:
  file.managed:
  - source: salt://ironic/files/{{ server.version }}/ironic.conf.{{ grains.os_family }}
  - template: jinja
  - require:
    - pkg: ironic_packages

ironic_install_database:
  cmd.run:
  - names:
    - ironic-dbsync --config-file /etc/ironic/ironic.conf upgrade
  - require:
    - file: /etc/ironic/ironic.conf

{%- endif %}
