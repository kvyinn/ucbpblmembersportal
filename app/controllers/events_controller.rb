class EventsController < ApplicationController

  def new_show
    @calendar_id = revert_google_calendar_id(params[:calendar_id] || pbl_events_calendar_id)

    @event = google_api_request(
      'calendar', 'v3', 'events', 'get', {
        eventId: params[:id],
        calendarId: @calendar_id
      }
    ).data

    @attendees = EventMember.where(event_id: Event.where(google_id: @event.id).first.id).map do |event_member|
      event_member.member
    end.uniq

    @taking_attendance = params[:calendar_id].nil?
  end

  def new_index
    # sync_events_with_google
    # asdf_events
    # sync_event_points
    # EventPoints.destroy_all
    # sync_event_members
    # swap_ids
    @calendar_id = revert_google_calendar_id(params[:calendar_id] || pbl_events_calendar_id)

    past_events = google_api_request(
      'calendar', 'v3', 'events', 'list',
      {
        calendarId: @calendar_id,
        timeMin: beginning_of_fall_semester,
        timeMax: DateTime.now,
      }
    ).data.items

    upcoming_events = google_api_request(
      'calendar', 'v3', 'events', 'list',
      {
        calendarId: @calendar_id,
        timeMin: DateTime.now,
        timeMax: DateTime.now + 1.month,
      }
    ).data.items

    @past_events = process_google_events(past_events)
    @upcoming_events = process_google_events(upcoming_events)
    render "index"
  end



  def index
    @attended_events = Array.new
    current_member.event_members.each do |event_member|
      @attended_events << Event.where(id: event_member.event_id).first
    end

    @past_events = Array.new
    @upcoming_events = Array.new
    Event.all.each do |event|
      if event.start_time < DateTime.now
        @past_events << event
      else
        @upcoming_events << event
      end
    end

    @past_events = sort(@past_events, params[:sort], params[:direction])
    render "new_index"
  end



  def show
    @event = Event.find(params[:id])
    @attendees = @event.attendees
    render "new_show"
  end
  # def swap_ids
  #   EventPoints.all.each do |e|
  #     gid = e.google_id
  #     eid = e.event_id
  #     e.google_id = eid
  #     e.event_id = gid
  #     e.save
  #   end
  # end
  # def asdf_events
  #   EventMember.all.each do |em|
  #     google_id = em.event_id
  #     event = Event.where(google_id: google_id).first
  #     if event
  #       em.event_id = event.id
  #       em.save
  #     end
  #   end
  # end

  # def sync_event_members
  #   EventMember.all.each do |em|
  #     event = Event.where(google_id: em.event_id).first
  #     if event
  #       em.google_id = event.id
  #       em.save
  #     else
  #       puts "failed to save"
  #     end
  #   end
  # end

  # def sync_event_points
  #   EventPoints.all.each do |ep|
  #     event = Event.where(google_id: ep.event_id).first
  #     begin
  #       ep.event_id = event.id
  #       ep.save
  #     rescue
  #       "you can't do dat its not unique"
  #       # ep.destroy
  #     end
  #   end
  # end

  def sync_events_with_google
    @calendar_id = revert_google_calendar_id(pbl_events_calendar_id)
    puts "these are time min and maxes"
    puts beginning_of_fall_semester
    puts (DateTime.now + 6.month)
    puts "end of those two"
    all_events = google_api_request(
      'calendar', 'v3', 'events', 'list',
      {
        calendarId: @calendar_id,
        # timeMin: beginning_of_fall_semester,
        # timeMax: (DateTime.now + 6.month),
      }
    ).data.items
    puts all_events
    puts "that was all events"
    # add these events to event model
    all_events = process_google_events(all_events)
    all_events.each do |e|
      event = Event.new
      if Event.where(google_id: e[:id]).length != 0
        event = Event.where(google_id: e[:id]).first
      end
      if e[:start_time] and e[:end_time]
        event.google_id = e[:id]
        event.start_time = e[:start_time]
        event.end_time = e[:end_time]
        event.name = e[:summary]
        event.save
      end
    end
    redirect_to(:back)
  end


  # sorts array by sort parameter and returns sorted array
  def sort(array, sort_param, direction)
    if sort_param == "points"
      if direction == "asc"
        array = array.sort! {|x,y| x.points <=> y.points}
      else
        array = array.sort! {|y,x| x.points <=> y.points}
      end
    end
    if sort_param == "name"
      if direction == "desc"
        array = array.sort! {|x,y| x.name <=> y.name}
      else
        array = array.sort! {|y,x| x.name <=> y.name}
      end
    end
    if sort_param == "date"
      if direction == "desc"
        array = array.sort! {|x,y| x.start_time <=> y.start_time}
      else
        array = array.sort! {|y,x| x.start_time <=> y.start_time}
      end
    end
    if sort_param == "attendees"
      if direction == "asc"
        array = array.sort! {|x,y| x.attendees.length <=> y.attendees.length}
      else
        array = array.sort! {|y,x| x.attendees.length <=> y.attendees.length}
      end
    end
    return array
  end

  # helper methods ni the controller
  def pbl_events_calendar_id
    '8bo2rpf4joem2kq9q2n940p1ss@group.calendar.google.com'
  end

  def process_google_events(events, options={})
    results = []
    events.each do |event|
      start_time = google_datetime_fix(event.start)
      end_time = google_datetime_fix(event.end)

      if options[:this_week]
        start_time = this_week(start_time)
        end_time = this_week(end_time)
      end

      results << {
        id: event.id,
        summary: event.summary,
        start_time: start_time,
        end_time: end_time,
      }
    end

    return results.sort_by {|event| event[:start_time]}
  end

  def google_datetime_fix(datetime)
    time_string = datetime.date_time ? datetime.date_time.to_s : datetime.date.to_s
    DateTime.parse(time_string)
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    # css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

end
