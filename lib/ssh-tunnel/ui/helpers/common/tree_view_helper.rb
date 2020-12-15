# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module Common
        module TreeViewHelper

          def add_text_column(treeview, label, attributes)
            renderer = Gtk::CellRendererText.new
            add_column(treeview, renderer, label, attributes)
          end


          def add_image_column(treeview, label, attributes)
            renderer = Gtk::CellRendererPixbuf.new
            add_column(treeview, renderer, label, attributes)
          end


          def add_column(treeview, renderer, label, attributes)
            visible  = attributes.delete(:visible) { true }
            sortable = attributes.delete(:sortable) { true }

            column = Gtk::TreeViewColumn.new(label, renderer, attributes)
            column.visible = visible

            if sortable
              column.clickable = true
              column.sort_column_id = attributes[:text] if attributes[:text]
            end

            treeview.append_column(column)
          end

        end
      end
    end
  end
end
