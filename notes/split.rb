#!/bin/env/ruby
require "stupidedi"
require "pp"

# Restructures the syntax tree so each transaction set is the only
# child of its parent functional group, which is the only child of
# its parent interchange, which is the only child of the transmission.
#
# This can be used to print each transaction set as a separate file,
# including the outer envelopes. Yields each transaction set to the
# caller.
def split(isa)
  isa.find(:IEA)
    .flatmap{|iea| replace(iea, 1, "1") }
    .flatmap(&:parent)
    .tap do |isa|
      only(isa).iterate(:GS) do |gs|
        gs.find(:GE)
          .flatmap{|ge| replace(ge, 1, "1") }
          .flatmap{|ge| replace(ge, 2, "1") }
          .flatmap(&:parent)
          .flatmap{|gs| replace(gs, 6, "1") }
          .tap do |gs|
            only(gs).iterate(:ST) do |st|
              st.find(:SE)
                .flatmap{|se| replace(se, 2, "1") }
                .flatmap(&:parent)
                .flatmap{|st| replace(st, 2, "1") }
                .tap{|st| yield(only(st, 2)) }
            end
          end
      end
    end
end

def replace(machine, index, value)
  machine.element(index).map do |element|
    element = element.replace(element.node.copy(:value => value))
    segment = machine.active.first
    segment = segment.replace(segment.node.copy(:zipper => element.up))
    Stupidedi::Builder::StateMachine.new(machine.config, [segment])
  end
end

# Rewrites the state and syntax trees so the ancestor of the current
# segment (eg, transaction set, functional group, interchange) is the
# only non-segment child of its parent. That is, if we're positioned
# at GS, the aunt functional groups are removed, but the aunt ISA and
# IEA segments are preserved.
#
#  [ISA] -- ( Functional Group ) -- ( Functional Group ) -- [IEA]
#                    |                       |
#                  [GS]                    [GS]
#
def only(machine, depth=1)
  active = machine.active.map do |state|
    value = state.node.zipper

    _value = value; depth.times { _value = _value.up }
    _state = state; depth.times { _state = _state.up }

    vaunts = [_value.node]
    saunts = [_state.node]

    # Skip rightward non-segment siblings
    vcursor = _value
    scursor = _state
    until vcursor.last?
      vcursor = vcursor.next
      scursor = scursor.next
      if vcursor.node.segment?
        vaunts.push(vcursor.node)
        saunts.push(scursor.node)
      end
    end

    # Skip leftward non-segment siblings
    offset  = 0
    vcursor = _value
    scursor = _state
    until vcursor.first?
      vcursor = vcursor.prev
      scursor = scursor.prev
      if vcursor.node.segment?
        offset += 1
        vaunts.unshift(vcursor.node)
        saunts.unshift(scursor.node)
      end
    end

    _value = _value.up.bind{|z| z.replace(z.node.copy(:children => vaunts)) }.child(offset)
    _state = _state.up.bind{|z| z.replace(z.node.copy(:children => saunts)) }.child(offset)

    value = _value; depth.times { value = value.down }
    state = _state; depth.times { state = state.down }

    state.bind{|z| z.replace(z.node.copy(:zipper => value)) }
  end

  Stupidedi::Builder::StateMachine.new(machine.config, active)
end

config = Stupidedi::Config.hipaa
reader = Stupidedi::Reader.build(File.read("notes/split.edi", :encoding => "ISO-8859-1"))
parser = Stupidedi::Builder::StateMachine.build(config)

parser, result = parser.read(reader)

parser.first.tap do |isa|
  split(isa) do |st|
    st.zipper.tap{|z| pp z.root.node }
  end

  isa.iterate(:ISA) do |isa|
    split(isa) do |st|
      st.zipper.tap{|z| pp z.root.node }
    end
  end
end
