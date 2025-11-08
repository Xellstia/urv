# frozen_string_literal: true

module IconHelper
  # Рендерит SVG-иконку.
  # Приоритет:
  # 1) app/assets/images/ui/<name>.svg — инлайнится целиком (предпочтительно)
  # 2) fallback из ICONS ниже (как было раньше)
  #
  # Примечание: чтобы иконка окрашивалась цветом текста ссылки,
  # в вашем SVG лучше указать fill="currentColor" и/или stroke="currentColor".
  def icon(name, classes: "w-8 h-8", aria_label: nil)
    name = name.to_s
    inline = inline_svg_from_ui_folder(name, classes: classes, aria_label: aria_label)
    return inline if inline

    # Fallback на старый встроенный набор
    svg = ICONS[name.to_sym]
    return "" unless svg

    label_attr =
      if aria_label.present?
        %( aria-label="#{ERB::Util.h aria_label}" role="img")
      else
        %( aria-hidden="true")
      end

    %(<svg class="#{ERB::Util.h classes}" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="2"#{label_attr}>#{svg}</svg>).html_safe
  end

  private

  # Пытаемся прочитать ui/<name>.svg из app/assets/images и инлайнить.
  def inline_svg_from_ui_folder(name, classes:, aria_label:)
    path = Rails.root.join("app/assets/images/ui/#{name}.svg")
    return nil unless File.exist?(path)

    svg = File.read(path)

    # В svg первый тег <svg ...> — добавим class + aria-атрибуты (если их нет)
    label_attr =
      if aria_label.present?
        %( aria-label="#{ERB::Util.h aria_label}" role="img")
      else
        %( aria-hidden="true")
      end

    if svg =~ /<svg\b[^>]*>/
      # если уже есть class="...", аккуратно добавим наши классы в конец
      if svg =~ /<svg\b[^>]*\bclass=["']([^"']*)["']/i
        svg.sub!(/(<svg\b[^>]*\bclass=["'])([^"']*)(["'])/i) do
          %(#{$1}#{$2} #{ERB::Util.h classes}#{$3})
        end
      else
        # нет class — просто подставляем
        svg.sub!(/<svg\b/i, %(<svg class="#{ERB::Util.h classes}"#{label_attr}))
        # если уже подставили aria вместе с class — не дублируем ниже
        label_attr = nil
      end

      # если aria ещё не подставили
      svg.sub!(/<svg\b([^>]*)>/i, "<svg\\1#{label_attr}>") if label_attr
    end

    svg.html_safe
  rescue => e
    Rails.logger.warn("[IconHelper] Failed to inline SVG ui/#{name}.svg: #{e.class} #{e.message}")
    nil
  end

  # --- Встроенные fallback-иконки (оставили как было) ---
  ICONS = {
    menu:     %(<path d="M4 6h16M4 12h16M4 18h16"/>),
    calendar: %(<path d="M18,5V3a1,1,0,0,0-2,0V5H8V3A1,1,0,0,0,6,3V5H5A3,3,0,0,0,2,8V19a3,3,0,0,0,3,3H19a3,3,0,0,0,3-3V8A3,3,0,0,0,19,5Zm1,14H5a1,1,0,0,1-1-1V11H20v7A1,1,0,0,1,19,19Z"/>),
    list:     %(<path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/>),
    grid:     %(<rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/>),
    gear:     %(<path d="M12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Zm8.09-2.27a8 8 0 0 0 .06-1.46l2-1.55a1 1 0 0 0 .24-1.31l-1.9-3.29a1 1 0 0 0-1.21-.44l-2.36 1a7.94 7.94 0 0 0-1.26-.73l-.36-2.51A1 1 0 0 0 13.08 1h-3.8a1 1 0 0 0-1 .84l-.36 2.51a7.94 7.94 0 0 0-1.26.73l-2.36-1a1 1 0 0 0-1.21.44L.19 8.12A1 1 0 0 0 .43 9.43l2 1.55a8 8 0 0 0 0 1.46l-2 1.55a1 1 0 0 0-.24 1.31l1.9 3.29a1 1 0 0 0 1.21.44l2.36-1c.41.29.83.54 1.26.73l.36 2.51a1 1 0 0 0 1 .84h3.8a1 1 0 0 0 1-.84l.36-2.51a7.94 7.94 0 0 0 1.26-.73l2.36 1a1 1 0 0 0 1.21-.44l1.9-3.29a1 1 0 0 0-.24-1.31l-2-1.55Z"/>),
    logout:   %(<path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><path d="M10 17l5-5-5-5"/><path d="M15 12H3"/>)
  }.freeze
end
