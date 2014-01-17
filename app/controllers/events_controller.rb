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
    @calendar_id = revert_google_calendar_id(params[:calendar_id] || pbl_events_calendar_id)
    @past_events = Array.new
    # Event.where(:start_time < DateTime.now)
    @upcoming_events = Array.new
    # Event.where(:start_time >= DateTime.now)
    Event.all.each do |event|
      if event.start_time < DateTime.now
        @past_events << event
      else
        @upcoming_events << event
      end
    end
    render "new_index"
  end

  def show
    @event = Event.find(params[:id])
    @attendees = EventMember.where(event_id: @event.id).map do |event_member|
      event_member.member
    end.uniq
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
    @calendar_id = revert_google_calendar_id(params[:calendar_id] || pbl_events_calendar_id)

    all_events = google_api_request(
      'calendar', 'v3', 'events', 'list',
      {
        calendarId: @calendar_id,
        timeMin: beginning_of_fall_semester,
        timeMax: DateTime.now + 6.month,
      }
    ).data.items
    # add these events to event model
    all_events = process_google_events(all_events)
    all_events.each do |e|
      if Event.where(google_id: e[:id]).length == 0
        event = Event.new
        event.google_id = e[:id]
        event.start_time = e[:start_time]
        event.end_time = e[:end_time]
        event.name = e[:summary]
        event.save
      else
        event = Event.where(google_id: e[:id]).first
        event.semester_id = 1
        event.save
      end
    end
  end


end
