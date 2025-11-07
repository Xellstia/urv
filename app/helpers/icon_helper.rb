# frozen_string_literal: true

module IconHelper
  # Центральный хелпер иконок (outline, currentColor).
  # По умолчанию иконки крупные (w-8 h-8) и белые за счёт текста ссылки.
  def icon(name, classes: "w-8 h-8", aria_label: nil)
    svg = ICONS[name.to_sym]
    return "" unless svg

    label_attr = aria_label.present? ? %( aria-label="#{ERB::Util.h aria_label}" role="img") : %( aria-hidden="true")
    %(<svg class="#{ERB::Util.h classes}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"#{label_attr}>#{svg}</svg>).html_safe
  end

  ICONS = {
    # Общие
    menu:     %(<path d="M4 6h16M4 12h16M4 18h16"/>),
    calendar: %(<path d="M18,5V3a1,1,0,0,0-2,0V5H8V3A1,1,0,0,0,6,3V5H2V21H22V5Zm2,14H4V7H20Zm-3.94-7.58-1.2-1.2L11.3,13.78,9.14,11.63l-1.2,1.2,3.36,3.36Z"/>),
    list:     %(<path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/>),
    grid:     %(<rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/>),
    gear:     %(<path d="M12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 8.4 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06A2 2 0 1 1 3.69 16.9l.06-.06a1.65 1.65 0 0 0 .33-1.82A1.65 1.65 0 0 0 2.5 14H2.41a2 2 0 0 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06A2 2 0 1 1 6.1 3.69l.06.06a1.65 1.65 0 0 0 1.82.33H8.09A1.65 1.65 0 0 0 9.6 2.5V2.41a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51h.09a1.65 1.65 0 0 0 1.82-.33l.06-.06A2 2 0 1 1 20.31 7.1l-.06.06a1.65 1.65 0 0 0-.33 1.82v.09A1.65 1.65 0 0 0 21.5 11.6h.09a2 2 0 0 1 0 4h-.09A1.65 1.65 0 0 0 19.4 15Z"/>),

    # Пользователь / сессия
    logout:   %(<path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><path d="M10 17l5-5-5-5"/><path d="M15 12H3"/>)
  }.freeze
end
