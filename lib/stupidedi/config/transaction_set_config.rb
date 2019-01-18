# frozen_string_literal: true
module Stupidedi
  using Refinements

  class Config
    #
    # The implementation version specified in GS08 and ST03 indicates which
    # implementation guide governs the transaction.
    #
    # Note we can't look only at ST01 to link "837" to our definition of
    # 837P from the HIPAA guide without also considering "005010X222", because
    # thereare several different "837"s (including "005010X223", etc)
    #
    class TransactionSetConfig
      include Inspect

      # @return [Hash<[GS08, GS01, ST01], TransactionSetDef>]
      attr_reader :table

      def initialize
        @table = Hash.new
      end

      def customize(&block)
        tap(&block)
      end

      # @return [void]
      def register(gs08, gs01, st01, definition = nil, &constructor)
        if block_given?
          @table[Array[gs08, gs01, st01]] = constructor
        else
          @table[Array[gs08, gs01, st01]] = definition
        end
      end

      # @return [TransactionSetDef]
      def at(gs08, gs01, st01)
        x = @table[Array[gs08, gs01, st01]]
        x.is_a?(Proc) ? x.call : x
      end

      def defined_at?(gs08, gs01, st01)
        @table.defined_at?([gs08, gs01, st01])
      end

      # @return [void]
      def pretty_print(q)
        q.text "TransactionSetConfig"
        q.group(2, "(", ")") do
          q.breakable ""
          @table.keys.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end
  end
end
