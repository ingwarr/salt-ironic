{%- if pillar.ironic is defined %}
include:
{%- if pillar.ironic.server is defined %}
- ironic.server
{%- endif %}
{%- endif %}
