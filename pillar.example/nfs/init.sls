###
#  Users Pillar
#  ============
#  Add/remove users from system
###

nfs-exports:
  /data/media:
    127.0.0.1:
      #(ro,insecure,insecure_locks,root_squash,anongid=99,anonuid=99,no_subtree_check,async)
      secure: false
      mode: ro
      async: true
      no_subtree_check: true
      insecure_locks: true
      root_squash: true  # true / false / all
      anonuid: 99
      anongid: 99
    10.0.0.88:
      #(insecure,insecure_locks,no_subtree_check,rw,no_root_squash,async)
      secure: false
      mode: rw
      async: true
      no_subtree_check: true
      insecure_locks: true
      root_squash: false
    10.0.0.93:
      #(insecure,insecure_locks,no_subtree_check,ro,no_root_squash,async)
      secure: false
      mode: ro
      async: true
      no_subtree_check: true
      insecure_locks: true
      mountpoint: /data/media
      root_squash: false
    10.0.0.10:
      #(insecure,insecure_locks,no_subtree_check,rw,no_root_squash,async)
      secure: false
      mode: rw
      async: true
      no_subtree_check: true
      insecure_locks: true
      root_squash: false
