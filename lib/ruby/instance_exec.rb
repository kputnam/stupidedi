# frozen_string_literal: true
module Stupidedi
  module Refinements

    refine Object do
      if RUBY_VERSION < "1.9"
        module InstanceExecHelper; end
        include InstanceExecHelper

        # @see http://eigenclass.org/hiki/instance_exec
        def instance_exec(*args, &block)
          thread = Thread.current.object_id.abs
          object = object_id.abs
          mname  = "__instance_exec_#{thread}_#{object}"
          InstanceExecHelper.module_eval { define_method(mname, &block) }

          begin
            __send__(mname, *args)
          ensure
            begin
              InstanceExecHelper.module_eval { remove_method(mname) }
            rescue
            end
          end
        end
      end
    end

  end
end
