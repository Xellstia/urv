// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// === 1. Автоматическая загрузка всех контроллеров из app/javascript/controllers ===
eagerLoadControllersFrom("controllers", application)

// === 2. (опционально) Явно регистрируем нестандартные или внешние ===
import WeekendToggleController from "./weekend_toggle_controller"
import TimeInputController from "./time_input_controller"
import FrameCloseController from "./frame_close_controller"

application.register("frame-close", FrameCloseController)
application.register("weekend-toggle", WeekendToggleController)
application.register("time-input", TimeInputController)
