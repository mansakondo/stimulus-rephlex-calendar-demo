module Views
  class Calendar < PhlexibleCalendar::Views::Calendar
    def template(&block)
      div class: "flex justify-center", data: { controller: "events", action: "mouseup->events#stopResize"} do
        div class: "flex flex-col" do
          div class: "flex ml-16 py-8"do
            date_range.slice(0, 7).each do |day|
              div class: "flex flex-col" do
                span class: "text-md text-center text-gray-600 w-[160px]" do
                  t("date.abbr_day_names")[day.wday]
                end

                span class: "text-md text-center text-gray-500 w-[160px]" do
                  day.day
                end
              end
            end
          end

          div class: "overflow-auto h-[520px]" do
            div class: "flex" do
              div class: "flex flex-col w-16" do
                self.class.hours.each_with_index do |hour, i|
                  div class: "relative h-14" do
                    span class: "absolute bottom-12 text-xs text-gray-600" do
                      hour if i > 0
                    end
                  end
                end
              end

              date_range.slice(0, 7).each do |day|
                div class: "relative flex flex-col w-[160px]" do
                  times_for_quarter_hours(day).each_slice(4) do |times|
                    div class: "relative h-14 border" do
                      times.each_with_index do |time, i|
                        div class: "w-full", style: "height: 25%; top: #{25*i}%;", data: { action: "drop->events#drop dragover->events#setDropEffect", date: time.to_date, events_target: "eventSlot", time: time.strftime("%H:%M:%S %Z") } do
                          if block_given?
                            block.call sorted_events.fetch(time, [])
                          else
                            sorted_events.fetch(time, []).each_with_index do |event, i|
                              div id: event.send(start_attribute), class: "absolute flex justify-center items-center cursor-grab bg-gray-900 text-white text-xs rounded", style: "height: #{event.height_in_percentage}%; width: calc(100% - #{(i) * 10}px); z-index: #{i+1};#{(" border: groove;" if i > 0)} cursor: grab", draggable: "true", data: { date: time.to_date, time: event.send(start_attribute).strftime("%H:%M:%S %Z"), event_id: event.id, action: "dragstart->events#startDrag" } do
                                div class: "absolute w-full", style: "height: 12px; bottom: 100%; cursor: row-resize", data: { action: "mousedown->events#startResize", events_position_param: "start" } do
                                end
                                span do
                                  event.name
                                end
                                div class: "absolute w-full", style: "height: 12px; top: 100%; cursor: row-resize", data: { action: "mousedown->events#startResize", events_position_param: "end" } do
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end

          div class: "flex justify-around items-center mt-4" do
            a href: url_for_previous_view, class: "flex justify-center items-center h-10 w-10 bg-gray-900 text-white rounded-full " do
              t("phlexible_calendar.previous", default: "<")
            end

            a href: url_for_next_view, class: "flex justify-center items-center h-10 w-10 bg-gray-900 text-white rounded-full " do
              t("phlexible_calendar.next", default: ">")
            end
          end
        end
      end
    end
  end
end
