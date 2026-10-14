# CyberHawks Sigma style

- title: short and action-oriented ("SSH brute force from single source")
- logsource: product + service (for example `product: linux`, `service: sshd`)
- detection: a `selection`, plus a `condition`. For brute force, add a count and a
  timeframe (for example more than 10 failures from one IP in 5 minutes)
- falsepositives: list at least one realistic one
- level: low / medium / high, with a one-line reason

Always test the rule's logic against the sample log and show which events it flags.
