# app/helpers/icon_helper.rb
module IconHelper
  # Использование:
  #   <%= icon(:calendar) %>
  #   <%= icon(:logout, classes: "w-7 h-7 text-slate-600") %>
  #
  def icon(name, classes: "w-6 h-6", aria_label: nil)
    svg = ICONS[name.to_sym]
    return "" unless svg

    label_attr = aria_label.present? ? %( aria-label="#{h aria_label}" role="img") : %( aria-hidden="true")
    %(<svg class="#{h classes}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"#{label_attr}>#{svg}</svg>).html_safe
  end

  # Здесь лежат все контуры (можешь подменять под себя)
  ICONS = {
    # ——— общие / навигация ———
    menu:     %(<path d="M3 6h18M3 12h18M3 18h18"/>),
    calendar: %(<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>),
    list:     %(<path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/>),
    grid:     %(<rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/>),
    gear:     %(<path d="M12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 8.6 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.4 15a1.65 1.65 0 0 0-1.51-1H2.8a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.4 8.6a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 8.6 4.4 1.65 1.65 0 0 0 10.11 2.9H10.2a2 2 0 0 1 4 0v.09A1.65 1.65 0 0 0 15.4 4.6a1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 8.6 1.65 1.65 0 0 0 20.9 10.11v.09a2 2 0 0 1 0 4h-.09A1.65 1.65 0 0 0 19.4 15Z"/>),

    # ——— доменные ———
    presets:  %(<path d="M3 7h18M3 12h18M3 17h18"/>),
    templates:%(<rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/>),

    # ——— пользователь ———
    user:     %(<circle cx="12" cy="8" r="4"/><path d="M4 20c1.5-3 4.5-5 8-5s6.5 2 8 5"/>),
    logout:   %(<path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><path d="M10 17l5-5-5-5"/><path d="M15 12H3"/>)
  }.freeze
end
