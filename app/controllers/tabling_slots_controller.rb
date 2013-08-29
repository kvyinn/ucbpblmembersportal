class TablingSlotsController < ApplicationController

  def index
    tabling_slots = TablingSlot.order(:start_time)

    earliest_time = DateTime.now + 1.month;
    tabling_slots.each { |slot| earliest_time = slot.start_time if earliest_time > slot.start_time }

    @tabling_slot_hash = Hash.new
    tabling_slots.each do |slot|
      @tabling_slot_hash[slot.start_time] = slot
    end



    # NOTE: change to right ID
    @members_calendar_id = "pjnj2vfdlcui8n9244teaekvds@group.calendar.google.com"
  end

  def generate
    generate_schedule
    redirect_to tabling_slots_path
  end

  def add_to_google_calendar
    @members_calendar_id = "pjnj2vfdlcui8n9244teaekvds@group.calendar.google.com"
    @tabling_slots = TablingSlot.order(:start_time)

    @tabling_slots.each do |tabling_slot|
      event = {
        start: { dateTime: tabling_slot.start_time },
        end: { dateTime: tabling_slot.end_time },
        summary: "Tabling for #{tabling_slot.members.map {|m| m.name}.to_sentence}",
      }
      result = google_api_request(
        'calendar', 'v3', 'events', 'insert',
        { calendarId: @members_calendar_id },
        JSON.dump(event)
      )
    end
  end

end
