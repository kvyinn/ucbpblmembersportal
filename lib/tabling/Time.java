package tablingassigner;

/**
 * Class to represent time and switch between literal and real representations.
 *
 * @author Keien
 */

public class Time {
    public Time(int hour, int minute) {
        _realTime = hour + minute / 60.0;
    }

    public Time(int literalTime) {
        _realTime = literalTime / 100 + (literalTime % 100)/60.0;
    }

    public Time(double realTime) {
        _realTime = realTime;
    }

    double getReal() {
        return _realTime;
    }

    int getLiteral() {
        int hours = (int)_realTime * 100;
        int minutes = (int)(Math.round((_realTime - (int)_realTime) * 60.0));
        return hours + minutes;
    }

    Time add(int literalTime) {
        return new Time((new Time(literalTime)).getReal() + this._realTime);
    }

    Time add(double realTime) {
        return new Time(realTime + this._realTime);
    }

    Time add(Time otherTime) {
        return new Time(otherTime.getReal() + this._realTime);
    }

    public String toString() {
        return "" + this.getLiteral();
    }

    private double _realTime;
}
