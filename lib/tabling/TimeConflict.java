package tablingassigner;

/**
 *
 * @author Rohin Jethani, Keien Ohta
 */

public class TimeConflict {

    public TimeConflict(String dow, int startDate, int endDate,
            int startTime, int endTime) {
        _dow = dow;
        _startDate = startDate;
        _endDate = endDate;
        _startTime = new Time(startTime);
        _endTime = new Time(endTime);
    }

    String daysOfWeek() {
        return _dow;
    }

    int startDate() {
        return _startDate;
    }

    int endDate() {
        return _endDate;
    }

    int startTime() {
        return _startTime.getLiteral();
    }

    int endTime() {
        return _endTime.getLiteral();
    }

    String _dow;
    private int _startDate;
    private int _endDate;
    private Time _startTime;
    private Time _endTime;
}
