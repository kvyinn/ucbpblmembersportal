package tablingassigner;

/**
 *
 * @author Rohin Jethani, Keien Ohta
 */
public enum Position {
    CM (3),
    CHAIR (4),
    EXEC (5);

    private final int val;
    Position(int val) {
        this.val = val;
    }

    int val() {
        return val;
    }
}
