---
- &1 !ruby/object:MachineState
  number: 1
  instruction_hash:
    :x:
    - :mark0
    - &4 !ruby/object:MachineState
      number: 2
      instruction_hash:
        :x:
        - :right
        - &3 !ruby/object:MachineState
          number: 3
          instruction_hash:
            :x:
            - :mark0
            - &5 !ruby/object:MachineState
              number: 4
              instruction_hash:
                :x:
                - :right
                - *1
                :0:
                - :right
                - *1
            :0:
            - :left
            - &2 !ruby/object:MachineState
              number: 5
              instruction_hash:
                :x:
                - :halt
                - *2
                :0:
                - :halt
                - *2
        :0:
        - :right
        - *3
    :0:
    - :markx
    - *2
- *4
- *3
- *5
- *2
