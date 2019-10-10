# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Writer
    class Claredi
      def initialize(node)
        @node = node
      end

      # @return [String]
      def write(out = StringIO.new)
        out << %Q(<html lang="en"><head>)
        out << %Q(<meta charset="iso-8859-1">)
        out << style
        out << js
        out << "</head><body>"
        build(@node, out)
        out << "</body></html>"
        out
      end

    private

      def js
        <<-JS
        <script type="text/javascript">
          function toggle() {
            var trim = document.getElementsByClassName("trim");
            for (var k = 0; k < trim.length; k ++)
              trim[k].classList.toggle("hide");
          }
        </script>
        JS
      end

      # @return [String]
      def style
        <<-CSS
        <style>
          body { font-size: 0.75em; }

          .interchange, .functionalgr, .table, .loop > .label {
            font-weight: bold;
            font-family: Optima, Trebuchet, sans-serif;
          }

          .interchange, .functionalgr, .transaction {
            margin-left:   1em;
          }

          .transaction {
            margin-top:    1.5em;
            margin-bottom: 1em;
          }

          .transaction > .label {
            font-weight: bold;
            font-size: 1.5em;
          }

          .table, .loop {
            margin-top:    0.5em;
            margin-bottom: 0.5em;
            margin-left:   0.5em;
          }

          .table { margin-left: 1em; margin-bottom: 2em; }

          .table        > .label/*
          .interchange  > .label,
          .functionalgr > .label*/ {
            font-size:     1.25em;
            border-bottom: 3px solid black;
            margin-top:    1em;
            margin-bottom: 0.5em;
          }

          .loop { border: 1px solid grey; border-right: 0; }
          .loop > .label { padding: 3px; background-color: #ddd; }
          .loop > .segment { margin: 3px 0 3px 6px; }

          .segment {
            font-weight: normal;
            font-family: 'Andale Mono', Monospace, monospace;
          }

          .segment .label:first-child { font-weight: bold; }

          .trim { color: #bbb; display: inline; }
          .hide { display: none; }

          #form {
            display:          block;
            padding:          3px;
            border:           1px solid #ccc;
            margin:           3px 3px 30px 3px;
            font-family:      Optima, Trebuchet, sans-serif;
            background-color: #eee;
          }
        </style>
        CSS
      end

      # @return [void]
      def build(node, out)
        if node.element?
          if node.composite?
            tmp = StringIO.new
            node.children.each{|e| build(e, tmp) }
            tmp.string.gsub!(%r{^(<span [^>]+>):}, "\\1*")
            tmp.string.gsub!(%r{((?:<span [^<]+>:?</span>)+)$}, %Q(<em class="trim hide">\\1</em>))
            out << tmp.string
          elsif node.component?
            out << %Q(<span class="label" title="#{node.definition.name}">:#{node.to_x12}</span>)
          elsif node.repeated?
            tmp = StringIO.new
            node.children.each{|e| build(e, tmp) }
            tmp.string.gsub!("*", "^")
            out << tmp.string
          else
            out << %Q(<span class="label" title="#{node.definition.name}">*#{node.to_x12}</span>)
          end

        elsif node.segment?
          out << %Q(<div class="segment"><span class="label" title="#{node.definition.name}">)
          out << node.definition.id
          out << "</span>"
          tmp  = StringIO.new
          node.children.each{|e| build(e, tmp) }
          tmp.string.gsub!(%r{((?:<span [^>]+>\*</span>)+)$}, %Q(<div class="trim hide">\\1</div>))
          out << "#{tmp.string}~</div>\n"

        elsif node.loop?
          if m = /^(\d\w+)(?: [:-])? (.+)$/.match(node.definition.id)
            id   = m.captures[0]
            name = m.captures[1]
            name = name.split(/\s+/).map(&:capitalize).join(" ")
            out << %Q(<div class="loop"><div class="label">#{name} (#{id})</div>\n)
          else
            out << %Q(<div class="loop"><div class="label">#{node.definition.id}</div>\n)
          end

          node.children.each{|c| build(c, out) }
          out << "</div>\n"

        elsif node.table?
          out << %Q(<div class="table"><div class="label">#{node.definition.id}</div>\n)
          node.children.each{|c| build(c, out) }
          out << "</div>\n"

        elsif node.transaction_set?
          out << %Q(<div class="transaction"><div class="label">Transaction Set #{node.definition.id}</div>\n)
          node.children.each{|c| build(c, out) }
          out << "</div>\n"

        elsif node.functional_group?
          out << %Q(<div class="functionalgr">)
        # out << %Q(<div class="label">Functional Group (#{node.definition.id})</div>\n)
          node.children.each{|c| build(c, out) }
          out << "</div>\n"

        elsif node.interchange?
          out << %Q(<div class="interchange">)
        # out << %Q(<div class="label">Interchange (#{node.definition.id})</div>\n)
          node.children.each{|c| build(c, out) }
          out << "</div>\n"

        elsif node.transmission?
          out << %Q(<label id="form"><input type="checkbox" id="hide" onchange="toggle()" checked/> Hide empty suffixes</label>)
          out << %Q(<div class="transmission">\n)
          node.children.each{|c| build(c, out) }
          out << "</div>\n"
        end
      end
    end
  end
end
