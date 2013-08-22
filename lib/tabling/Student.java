package tablingassigner;

import java.util.Set;
import java.util.HashMap;
import java.util.HashSet;

/** A single student, and all of the relevant information.
 *
 * @author Rohin Jethani, Keien Ohta
 */
public class Student {

    public Student(int ssid, String name, Position position) {
        _ssid = ssid;
        _name = name;
        _pos = position;
        _assignedTablingSlots = new HashSet<TablingSlot>();
    }

    public Student(int ssid, Position position) {
        _ssid = ssid;
        _pos = position;
        _assignedTablingSlots = new HashSet<TablingSlot>();
    }


    /** The student's SSID.
     * @return An integer representing the SSID.
     */
    int SSID() {
        return _ssid;
    }

    String name() {
        return _name;
    }

    Position position() {
        return _pos;
    }

    HashSet<TimeConflict> tcSet() {
        return _tcSet;
    }

    boolean isFullyAssigned() {
        return _assignedTablingSlots.size() == requiredTabling();
    }
    
    

    int requiredTabling() {
        if (position() == Position.CM) {
            return TablingAssigner.CM_REQ_TABLING;
        } else if (position() == Position.CHAIR) {
            return TablingAssigner.CHAIR_REQ_TABLING;
        } else if (position() == Position.EXEC) {
            return TablingAssigner.EXEC_REQ_TABLING;
        } else {
            throw new IllegalArgumentException("Invalid or null position for student " + SSID());
        }
    }

    Set<TablingSlot> assignedTablingSlots() {
        return _assignedTablingSlots;
    }

    /** Finds the tabling slot that has been assigned to this student that
     * contains the half hour HH. There should never be two, so if this finds
     * two, it will throw an exception.
     * @param hh - A half hour that return value must contain.
     * @return 
     */
    TablingSlot assignedSlotWithHalfHour(HalfHour hh) {
        TablingSlot result = null;
        for (TablingSlot ts : _assignedTablingSlots) {
            if(ts.containsHalfHour(hh)) {
                if (result != null) {
                    throw new IllegalArgumentException("Student " + SSID() + " had two tabling slots assigned that overlapped. Debug this.");        
                } else if (!ts.containsStudentStrongly(this)){
                    throw new IllegalArgumentException("There's an error here.");
                } else {
                    result = ts;
                }
            }
        }
        return result;
    }

    Set<TablingSlot> currentAvailableSlots(int prefLevel) {
        Set<TablingSlot> allAvailableSlots = availableSlots(prefLevel);
        Set<TablingSlot> currentAvailableSlots = new HashSet<TablingSlot>();
        for (TablingSlot ts : allAvailableSlots) {
            // check that the slot isnt full.
            // also check that this student isn't already assigned to this tabling slots
            // does double checking, remove one to optimize.
            if (!ts.isFull() && (ts.containsStudentWeakly(this) == null) && !_assignedTablingSlots.contains(ts)) {
                currentAvailableSlots.add(ts);
            }
        }     
        return currentAvailableSlots;
    }
    
//    Set<TablingSlot> nonOverlapAvailableSlots(int prefLevel) {
//        HashSet<TablingSlot> tsSet = availableSlots(prefLevel);
//        
//        
//        // Take out tabling slots that overlap with ones that are already assigned
//        // to this student.
//        HashSet<TablingSlot> result = new HashSet<TablingSlot>();
//        for (TablingSlot ts : tsSet) {
//            if (!ts.containsStudentWeakly(this)) {
//                result.add(ts);
//            }
//        }
//        if (result.isEmpty()) {
//            System.out.println(tsSet.size());
//            System.out.println("is empty.");
//        }
//        
//        return result;
//        
//    }

    void assignTablingSlot(TablingSlot ts) {
        if (ts.isFull()) {
            throw new IllegalArgumentException("Trying to assign to full tabling slot."); // change.
        } else if (this.isFullyAssigned()) {
            throw new IllegalArgumentException("Trying to assign a student who is already fully assigned.");
        } else if (ts.containsStudentWeakly(this) != null) {
            throw new IllegalArgumentException("Trying to assign overlapping tabling slot.");
        }
        _assignedTablingSlots.add(ts);
        ts.assignStudent(this);
    }
    

    
    void unassignTablingSlot(TablingSlot ts) {
        if (_assignedTablingSlots.contains(ts) && ts.containsStudentStrongly(this)) { // double checking, remove to optimize
            ts.removeStudent(this);
            _assignedTablingSlots.remove(ts);
        } else {
            throw new IllegalArgumentException("Trying to unassign slot that was not assigned.");
        }
    }


    /** Computes the Tabling Slots this student is available to table at.
     *
     * @param prefLevel The preference configuration for the available slots
     *   allowed. This is directly passed in from configuration file.
     *   // KEIEN - This is for you to decide how to use. You will certainly
     *   // need this flexibility, but its up to you what each prefLevel should
     *   // mean, and how granular it needs to be.
     *   // i.e. 1 may mean "literally all slots that he/she is available for.
     *   // 4 may mean "only slots that are the hour after a class ends or
     *   // the hour before it starts but not before the first class.
     *   // 2, 3 could be somewhere in between.. whatever you want.
     * @return A set of tabling slots for which this student is available to
     *   table for given preference limitations.
     */
    HashSet<TablingSlot> availableSlots(int prefLevel) {
        // This method works by first generation a two-by-two matrix
        // representation of a week's worth of tabling, then going through the
        // student's tcSet and zeroing the slots that have conflicts. Note
        // that the tabling slot configuration used to generate the matrix is
        // in the TablingSlot class.

        int[][] slotMatrix= new int[DayOfWeek.values().length][TablingSlot.slotsPerDay()];
        for (int i=0; i<slotMatrix.length; i++) {
            for (int j=0; j<slotMatrix[0].length; j++) {
                Time slotTime = new Time(j*TablingSlot.slotInterval().getReal() + TablingSlot.startOfDay().getReal());
                slotMatrix[i][j] = slotTime.getLiteral();
                // slotMatrix[i][j] = TablingSlot.startOfDay().getLiteral() + (j/2)*HOUR + (j%2)*TablingSlot.slotLength();
            }
        }
        
        // Testing
 //       System.out.println("Initial matrix:");
 //       for (int i=0; i<slotMatrix.length; i++) {
 //           System.out.print("| ");
 //           for (int j=0; j<slotMatrix[0].length; j++) {
 //               System.out.print(slotMatrix[i][j] + " ");
 //           }
 //           System.out.println("|");
 //       }
        

        // Removing conflicting slots
        if (this._tcSet != null) {
            for (TimeConflict tc : this._tcSet) {
//                System.out.println(tc.daysOfWeek() + " " + tc.startTime() + " " + tc.endTime());
                int[] colIndexes = _getSlotMatrixColIndexes(tc.daysOfWeek());
                int[] rowIndexes = _getSlotMatrixRowIndexes(tc.startTime(), tc.endTime());
                for (int i=0; i<colIndexes.length; i++) {
                    for (int j=0; j<rowIndexes.length; j++) {
                        if (colIndexes[i] != -1 && rowIndexes[j] != -1) {
                            slotMatrix[colIndexes[i]][rowIndexes[j]] = 0;
                        }
                    }
                }
            }
        }
        
        // Testing
//        System.out.println("After conflict removal:");
//        for (int i=0; i<slotMatrix.length; i++) {
//            System.out.print("| ");
//            for (int j=0; j<slotMatrix[0].length; j++) {
//                String printNum = slotMatrix[i][j] + " ";
//                if (printNum.equals("0 ")) printNum = "0000 ";
//                System.out.print(printNum);
//            }
//            System.out.println("|");
//        }
        

        // Generating HashSet of TablingSlots
        HashSet<TablingSlot> tsSet = new HashSet<TablingSlot>();
        for (int i=0; i<slotMatrix.length; i++) {
            DayOfWeek dow = _getDOW(i);
            for (int j=0; j<slotMatrix[0].length; j++) {
                if (slotMatrix[i][j] != 0) {
                    int startTime = slotMatrix[i][j];
                    int endTime = (new Time((new Time(startTime)).getReal() +
                          TablingSlot.slotLength().getReal())).getLiteral();
                    tsSet.add(new TablingSlot(dow, startTime, endTime));
                }
            }
        }
            
        return tsSet;
    }

    private int _ssid;
    private String _name;
    private Position _pos;
    private HashSet<TimeConflict> _tcSet;
    private Set<TablingSlot> _assignedTablingSlots;


    // Helper methods.. Please javadoc comment everything.

    /** Initializes the _tcSet field.
     *
     * @param tcMap The deserialized schedule file
     */
    public void getTimeConflicts(HashMap<Integer, HashSet<TimeConflict>> tcMap) {
        _tcSet = (HashSet<TimeConflict>)(tcMap.get(this._ssid));
    }

    /** Converts a String representation of the days of the week into an array
     *  of integers representing the column indexes in the slotMatrix.
     *
     * @param day A char representation of the day
     */
    private int[] _getSlotMatrixColIndexes(String day) {
        int[] colIndexes = new int[5];
        for (int i=0;i<colIndexes.length; i++) {
            if (day.charAt(i) != '-') {
                colIndexes[i] = i;
            }
            else {
                colIndexes[i] = -1;
            }
        }
        return colIndexes;
    }

    /** Generates a list of row indexes in the slotMatrix from the startTime
     *  and endTime of a TimeConflict.
     *
     *  @param startTime The starting time of the conflict
     *  @param endTime The ending time of the conflict
     */
    private int[] _getSlotMatrixRowIndexes(int startTime, int endTime) {
        // Some dumb person submitted a weird schedule...
        if (startTime >= endTime) return new int[0];

        // Check if starting and ending times are within range
        if (startTime >= TablingSlot.endOfDay().getLiteral() || endTime <= TablingSlot.startOfDay().getLiteral()) return new int[0];

        // Adjust start and end times if they go over the end times (add 0.5 to roud up)
        if (endTime > TablingSlot.endOfDay().getLiteral()) endTime = TablingSlot.endOfDay().getLiteral();
        if (startTime < TablingSlot.startOfDay().getLiteral()) startTime = TablingSlot.startOfDay().getLiteral();

        // Calculate number of slots that conflict within the time range
        int numSlots = (int)(Math.round(((new Time(endTime)).getReal() - (new Time(startTime)).getReal())
            / TablingSlot.slotInterval().getReal()) + 0.5);
        int[] rowIndexes = new int[numSlots];
        for (int i=0; i<rowIndexes.length; i++) {
            rowIndexes[i] = (int)(((new Time(startTime)).getReal()
                - TablingSlot.startOfDay().getReal())
                / TablingSlot.slotInterval().getReal()) + i;
            if (rowIndexes[i] >= TablingSlot.slotsPerDay()) { // If rounded up over the last slot
                rowIndexes[i] = -1;
            }
        }
        return rowIndexes;
    }

    /** Returns DayOfWeek for the given column index.
     *
     * @param colIndex The column index from the slotMatrix
     */
    private DayOfWeek _getDOW(int colIndex) {
        DayOfWeek return_dow = null;
        for (DayOfWeek dow : DayOfWeek.values()) {
             if (colIndex + 1 == dow.dayNum()) {
                return_dow = dow;
             }
        }
        return return_dow;
/*
        if (colIndex == 0) {
            return DayOfWeek.MONDAY;
        }
        else if (colIndex == 1) {
            return DayOfWeek.TUESDAY;
        }
        else if (colIndex == 2) {
            return DayOfWeek.WEDNESDAY;
        }
        else if (colIndex == 3) {
            return DayOfWeek.THURSDAY;
        }
        else if (colIndex == 4) {
            return DayOfWeek.FRIDAY;
        }
        else {
            return null;
        }
*/
    }
}
