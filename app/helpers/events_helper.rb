module EventsHelper

  def pbl_events_calendar_id
    '8bo2rpf4joem2kq9q2n940p1ss@group.calendar.google.com'
  end

  def process_google_events(events)
    results = []
    events.each do |event|
      results << {
        id: event.id,
        summary: event.summary,
        start_time: google_datetime_fix(event.start),
        end_time: google_datetime_fix(event.end),
      }
    end

    return results.sort_by {|event| event[:start_time]}
  end

  def google_datetime_fix(datetime)
    time_string = datetime.date_time ? datetime.date_time.to_s : datetime.date.to_s
    DateTime.parse(time_string)
  end

end
