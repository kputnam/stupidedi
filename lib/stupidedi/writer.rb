module Stupidedi
  module Writer

    class HtmlWriter

      #
      #
      def write(node, out = "")
        build(node, "<head>\n#{style}</head>\n<body>\n") << "</body>"
      end

      def style
        <<-CSS
        <style>
          body { font-size: 0.75em; }

          .interchange, .functionalgr, .table, .loop > .label {
            font-weight: bold;
            font-family: Georgia;
          }

          .interchange, .functionalgr, .transaction {
            margin-left:   1em;
            margin-top:    1em;
            margin-bottom: 1em;
          }

          .transaction > .label {
            font-weight: bold;
            font-size: 1.5em;
          }

          .table, .loop {
            margin-top:    0.5em;
            margin-bottom: 0.5em;
            margin-right:  0.5em;
          }

          .table { margin-left: 1em; margin-bottom: 2em; }
          .table > .label {
            font-size:     1.25em;
            border-bottom: 3px solid black;
            margin-top:    1em;
            margin-bottom: 0.5em;
          }

          .loop { border: 1px solid grey; border-left: 0; }
          .loop > .label {
            padding:          3px;
            background-color: #ddd;
          }

          .segment {
            display: inline;
            margin-top:  0.25em;
            background-color: #fff;
            font-weight: normal;
          }

          .segment > .label {
            font-weight: normal;
            font-family: Consolas, Monospace, monospace;
          }
        </style>
        CSS
      end

      def build(node, out = "")
        case node
        when Envelope::Transmission
          out << "<div class=transmission>\n"
          node.children.each{|c| build(c, out) }
          out << "</div>\n"

        when Envelope::InterchangeVal
          out << "<div class=interchange><div class=label>Interchange #{node.definition.id}</div>\n"
          node.children.each{|c| build(c, out) }
          out << "</div>\n"

        when Envelope::FunctionalGroupVal
          out << "<div class=functionalgr><div class=label>Functional Group #{node.definition.id}</div>\n"
          node.children.each{|c| build(c, out) }
          out << "</div>\n"

        when Envelope::TransactionSetVal
          out << "<div class=transaction><div class=label>Transaction Set #{node.definition.id}</div>\n"
          node.children.each{|c| build(c, out) }
          out << "</div>\n"

        when Values::TableVal
          out << "<div class=table><div class=label>#{node.definition.id}</div>\n"
          node.children.each{|c| build(c, out) }
          out << "</div>\n"

        when Values::LoopVal
          m = /^(\w+) (.+)$/.match(node.definition.id)
          id, name = m.captures
          name = name.split(/\s+/).map(&:capitalize).join(" ")

          out << "<div class=loop><div class=label>#{name} (#{id})</div>\n"
          node.children.each{|c| build(c, out) }
          out << "</div>\n"

        when Values::SegmentVal
          out << "<div class=segment><div class=label>#{'% 3s' % node.definition.id}"
        # out << ": #{node.definition.name}</div></div>\n"
          node.children.each{|e| build(e, out) }
          out.gsub!(/\**$/, "")
          out << "~</div></div>\n"

        when Values::SimpleElementVal
          if node.definition.parent.try(:component?)
            out << "#{node}:"
          else
            out << "*#{node}"
          end

        when Values::CompositeElementVal
          out << "*"
          node.children.each{|e| build(e, out) }
          out.gsub!(/:*$/, "")

        when Values::RepeatedElementVal
          out << "*"
          node.children.each{|e| build(e, out) }
        end
        out
      end

    end

  end
end
