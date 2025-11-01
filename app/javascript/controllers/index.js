// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import WeekendToggleController from "./weekend_toggle_controller"
import TimeInputController from "./time_input_controller"



application.register("weekend-toggle", WeekendToggleController)
application.register("time-input", TimeInputController)


eagerLoadControllersFrom("controllers", application)
