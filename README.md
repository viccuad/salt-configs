Debug salt on your client (the machine running the salt-minion) via:

 ```salt-call state.apply -l info test=True```

The code that describes the infrastructure is implementing the following pattern:

- Description of the infrastructure:

```
    []         Ids (identity of the machine. Eg: machine02)
   [] []       Roles (business logic. Eg: workstation, nas)
 [] [] []      Profiles (Configure whole stack. Eg: dns server)
[] [] [] []    Salt formulas (Configure part of the stack. eg: sshd)
```

- Data of the infrastructure: separated into the pillars.

This pattern is a best-practices one for Puppet, see [1] and [2].

[1]: https://docs.puppet.com/pe/2016.4/r_n_p_intro.html
[2]: https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern
