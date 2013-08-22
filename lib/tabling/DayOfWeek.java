package tablingassigner;

/** Enum for the weekdays.
 *
 * @author Keien Ohta, Rohin Jethani
 */
public enum DayOfWeek {
    MONDAY (1),
    TUESDAY (2),
    WEDNESDAY (3),
    THURSDAY (4),
    FRIDAY (5);

    private final int dayNum;
    DayOfWeek(int dayNum) {
        this.dayNum = dayNum;
    }

    int dayNum() {
        return dayNum;
    }
}
