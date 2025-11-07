# frozen_string_literal: true
module NavHelper
  def nav_link_to(label, path, icon:, active_when:)
    active = instance_exec(&active_when)

    classes = [
      "sidebar-item flex items-center gap-3 rounded-lg px-3 py-2",
      "text-slate-100 hover:bg-white/10",
      ("bg-white/15" if active)
    ].compact.join(" ")

    link_to path, class: classes, title: label do
      concat(icon(icon, classes: "w-8 h-8 shrink-0"))
      concat(content_tag(:span, label, class: "sidebar-label"))
    end
  end
end
