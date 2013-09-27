class TablingSlotsController < ApplicationController

  before_filter :admin_member, only: [ :generate, :add_to_google_calendar ]

  def index
    @tabling_slots = TablingSlot.where(
      "start_time >= :tabling_start and start_time <= :tabling_end",
      tabling_start: tabling_start,
      tabling_end: tabling_end,
    ).order(:start_time)

    if !@tabling_slots.empty?
      @earliest_time = @tabling_slots.first.start_time

      @tabling_days = Hash.new
      @tabling_slots.each do |tabling_slot|
        @tabling_days[tabling_slot.start_time.to_date] ||= Array.new
        tabling_day = @tabling_days[tabling_slot.start_time.to_date]

        tabling_day << tabling_slot
      end
    end

    # NOTE: change to right ID
    @members_calendar_id = "pjnj2vfdlcui8n9244teaekvds@group.calendar.google.com"
  end

  def print
    @tabling_slots = TablingSlot.where(
      "start_time >= :tabling_start and start_time <= :tabling_end",
      tabling_start: tabling_start,
      tabling_end: tabling_end,
    ).order(:start_time)

    if !@tabling_slots.empty?
      @earliest_time = @tabling_slots.first.start_time

      @tabling_days = Hash.new
      @tabling_slots.each do |tabling_slot|
        @tabling_days[tabling_slot.start_time.to_date] ||= Array.new
        tabling_day = @tabling_days[tabling_slot.start_time.to_date]

        tabling_day << tabling_slot
      end
    end

    render layout: "print"
  end

  def show
    @tabling_slot = TablingSlot.find(params[:id])
    @tabling_slot_member = TablingSlotMember.new
  end

  def generate
    if DateTime.now.cwday > 5 # If later than Friday
      write_init_files
      generate_schedule
      redirect_to tabling_slots_path
    else
      redirect_to tabling_slots_path, notice: "You cannot do that until after Friday"
    end
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
