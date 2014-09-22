#!yamlscript
#
# This is the default template.

# salt-call --local --out=yaml state.show_sls nfs.server
# salt-call --local state.highstate
$test_file:
  - salt://nfs/tests.server

# This module will create one state.  It will use pillar data to
# create data to populate the /etc/exports file

# Will set all the default values from salt; allows short pillar descriptions
#$defaults : True

# See notes above
$pillars:
  auto: False

# Main user add loop
$for name, values in pillar('nfs_exports', {}).items():
  $python: |
      if values is None:
          values = {}
      values.update(name=name)

      # self.update(values) will update ALL states with scope with values
      # and will return values wrapped in a ContentWrapper with allows dot
      # notation access.  In order to access dictionary directly within
      # a ContentWrapper, add ._data.  For example:

      #server_exports.file.contents = "This is the export"
      contents = "Replaced Content"

      # TODO:  Parse the pillar code and create contents sting from it!

# NFS Server states
nfs_server:
  pkg.installed:
    - name: nfs-kernel-server
  service.running:
    - name: nfs-kernel-server
    - require:
      - pkg: nfs-kernel-server
    - watch:
      - file: server_nfs_kernel_server
      - file: server_nfs_common
      - file: idmapd_conf
#  mount.mounted:
#    - name: /mnt/nfs
#    - device: /dev/xvdc
#    - fstype: ext3
#    - mkmnt: True
#    - opts:
#      - defaults

update_exports:
  cmd.run:
    - name: exportfs -ra
    - require:
      - pkg: nfs-kernel-server
    - watch:
      - file: server_exports

server_nfs_kernel_server:
  file.managed:
    - name: /etc/default/nfs-kernel-server
    - source: salt://nfs/server/nfs-kernel-server
    - user: root
    - group: root
    - mode: 644

server_nfs_common:
  file.managed:
    - name: /etc/default/nfs-common
    - source: salt://nfs/server/nfs-common
    - user: root
    - group: root
    - mode: 644

server_exports:
  file.managed:
    #- name: /etc/exports
    - name: /tmp/exports
    - contents: $contents
    - text: null
    - user: root
    - group: root
    - mode: 644

idmapd_conf:
  file.managed:
    - name: /etc/idmapd.conf
    - source: salt://nfs/server/idmapd.conf
    - user: root
    - group: root
    - mode: 644

