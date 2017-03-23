
==================================
ironic
==================================

Service ironic description

Sample pillars
==============

Single ironic service

.. code-block:: yaml

  ironic:
    server:
      enabled: true
      version: mitaka
      database:
        engine: mysql
        host: localhost
        port: 3306
        name: ironic
        user: ironic
        password: password 
      identity:
        engine: keystone
        region: RegionOne
        host: localhost
        port: 35357
        user: ironic
        password: password
        tenant: service
      bind:
        address: 0.0.0.0
        port: 6385
      message_queue:
        engine: rabbitmq
        host: localhost
        port: 5672
        user: openstack
        password: password
        virtual_host: '/openstack'

Standalone ironic without keystone

.. code-block:: yaml

  ironic:
    server:
      enabled: true
      version: mitaka
      database:
        engine: mysql
        host: localhost
        port: 3306
        name: ironic
        user: ironic
        password: password 
      identity:
        engine: noauth
      bind:
        address: 0.0.0.0
        port: 6385
      message_queue:
        engine: rabbitmq
        host: localhost
        port: 5672
        user: openstack
        password: password
        virtual_host: '/openstack'


Define drivers that should be loaded into ironic. Driver pxe_impitool is loaded by default.

.. code-block:: yaml

  ironic:
    server:
      drivers:
      - engine: pxe_ipmitool
      - engine: <driver>


