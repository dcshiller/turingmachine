---
- &8 !ruby/object:MachineState
  number: 1
  instruction_hash:
    :x:
    - :mark0
    - &7 !ruby/object:MachineState
      number: 2
      instruction_hash:
        :x:
        - :mark0
        - &6 !ruby/object:MachineState
          number: 3
          instruction_hash:
            :x:
            - :right
            - &1 !ruby/object:MachineState
              number: 4
              instruction_hash:
                :x:
                - :halt
                - *1
                :0:
                - :markx
                - &5 !ruby/object:MachineState
                  number: 5
                  instruction_hash:
                    :x:
                    - :mark0
                    - &4 !ruby/object:MachineState
                      number: 6
                      instruction_hash:
                        :x:
                        - :left
                        - &2 !ruby/object:MachineState
                          number: 7
                          instruction_hash:
                            :x:
                            - :left
                            - *2
                            :0:
                            - :right
                            - &3 !ruby/object:MachineState
                              number: 8
                              instruction_hash:
                                :x:
                                - :halt
                                - *3
                                :0:
                                - :halt
                                - *3
                        :0:
                        - :left
                        - *4
                    :0:
                    - :right
                    - *5
            :0:
            - :right
            - *6
        :0:
        - :halt
        - *7
    :0:
    - :halt
    - *8
- *7
- *6
- *1
- *5
- *4
- *2
- *3
