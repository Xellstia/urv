module NavHelper
  # Универсальная ссылка пункта меню с иконкой, акцентом и поддержкой свёрнутого сайдбара
  def nav_link_to(label, path, icon_svg:, active_when:)
    active = instance_exec(&active_when)
    classes = [
      "flex items-center gap-3 rounded-lg px-3 py-2",
      "hover:bg-slate-100 text-slate-700",
      ("bg-slate-100 text-slate-900" if active)
    ].compact.join(" ")

    content_tag :div do
      link_to path, class: classes do
        concat(content_tag(:span, icon_svg.html_safe, class: "w-5 h-5 shrink-0"))
        concat(content_tag(:span, label, class: "sidebar-label", "data-sidebar-target": "label"))
      end
    end
  end
end
