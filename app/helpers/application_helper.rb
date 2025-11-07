module ApplicationHelper
  # Цвет верхней полоски по статусу
  def state_color_classes(item)
    case item.state.to_s
    when "synced"     then "bg-emerald-500"
    when "draft"      then "bg-amber-500"
    else                   "bg-rose-500" # incomplete / прочее
    end
  end

  # Бейдж системы TEMPO / YAGA
  def system_badge_classes(item)
    item.system.to_s == "yaga" ? "bg-emerald-50 text-emerald-700 ring-1 ring-emerald-200" :
                                 "bg-blue-50 text-blue-700 ring-1 ring-blue-200"
  end

  # Формат минут в "Xh Ym"
  def minutes_human(minutes)
    m = minutes.to_i
    return "0m" if m <= 0
    h = m / 60
    r = m % 60
    h.positive? ? "#{h}h #{r}m" : "#{r}m"
  end

  def nav_link_to(name, path, icon_svg:, active_when: nil)
    active = active_when ? instance_exec(&active_when) : current_page?(path)
    base   = "flex items-center gap-3 rounded-lg px-3 py-2 hover:bg-slate-100"
    text   = active ? "text-slate-900 font-medium" : "text-slate-600"
    bg     = active ? "bg-slate-100" : ""
    content_tag :a, href: path, class: [base, text, bg].join(" ") do
      icon_svg.html_safe + content_tag(:span, name, class: "sidebar-label transition-opacity duration-150 opacity-100", data: { sidebar_target: "label" })
    end
  end
end
