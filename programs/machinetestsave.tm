---
- &6 !ruby/object:MachineState
  number: 1
  instruction_hash:
    :x:
    - :mark0
    - &1 !ruby/object:MachineState
      number: 2
      instruction_hash:
        :x:
        - :right
        - *1
        :0:
        - :right
        - &2 !ruby/object:MachineState
          number: 3
          instruction_hash:
            :x:
            - :right
            - *2
            :0:
            - :right
            - &3 !ruby/object:MachineState
              number: 4
              instruction_hash:
                :x:
                - :right
                - *3
                :0:
                - :markx
                - &4 !ruby/object:MachineState
                  number: 5
                  instruction_hash:
                    :x:
                    - :left
                    - *4
                    :0:
                    - :left
                    - &5 !ruby/object:MachineState
                      number: 6
                      instruction_hash:
                        :x:
                        - :left
                        - *5
                        :0:
                        - :right
                        - *6
    :0:
    - :right
    - &7 !ruby/object:MachineState
      number: 7
      instruction_hash:
        :x:
        - :halt
        - *7
        :0:
        - :halt
        - *7
- *1
- *2
- *3
- *4
- *5
- *7
