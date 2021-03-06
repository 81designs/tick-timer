module TimerRows

  def clear_timer(menu_item)
    timer = menu_item.object
    timer.clear
    build_menu
  end

  def timer_rows
    Tick::Timer.list.sort_by{|timer|
      timer.task.project.name.downcase
    }.map{|timer|
      title = timer.task.project.name + " - "
      title += timer.task.name + " - "
      title += timer.paused? ? "Paused" : timer.displayed_time
      {
        title: title,
        sections: [{
          rows: [{
            title: timer.paused? ? "Resume" : "Pause",
            target: self,
            action: "toggle_timer:",
            object: timer,
            type: :timer
          }, {
            title: "Clear",
            target: self,
            action: "clear_timer:",
            object: timer,
            type: :timer
          }]
        }, {
          rows: [{
            title: "Submit",
            target: self,
            action: "submit_timer:",
            object: timer,
            type: :timer
          }]
        }]
      }
    }
  end

  def submit_timer(menu_item)
    @submit_window_controller ||= SubmitWindowController.new
    @submit_window_controller.timer = menu_item.object
    @submit_window_controller.window.reset
    @submit_window_controller.showWindow(self)
    NSApp.activateIgnoringOtherApps(true)
  end

  def successful_submission
    build_menu
  end

  def toggle_timer(menu_item)
    timer = menu_item.object
    if timer.running?
      timer.stop
    else
      timer.start
    end
    build_menu
  end

end
